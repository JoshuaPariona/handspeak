import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

extension ListReshapeExtension<T> on List<T> {
  List<List<T>> reshape(List<int> dims) {
    if (dims.length != 2) throw Exception('Sólo reshape 2D soportado');
    int rows = dims[0];
    int cols = dims[1];
    if (rows * cols != this.length)
      throw Exception('Dimensiones no compatibles');
    List<List<T>> reshaped = List.generate(
      rows,
      (i) => List.filled(cols, this[0]),
    );
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        reshaped[i][j] = this[i * cols + j];
      }
    }
    return reshaped;
  }
}

final classes = [
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "H",
  "I",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z",
  "Ñ",
];

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isCameraActive = false;
  String _translatedText = '';
  Interpreter? interpreter;
  Timer? _timer;

  final int inputSize = 224;
  final int channels = 3;

  @override
  void initState() {
    super.initState();
    loadModel().then((_) => _initializeCameraWithPermission());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cameraController?.dispose();
    interpreter?.close();
    super.dispose();
  }

  Future<void> loadModel() async {
    try {
      final model = await FirebaseModelDownloader.instance.getModel(
        "sign_lang_recognition",
        FirebaseModelDownloadType.latestModel,
        FirebaseModelDownloadConditions(
          androidWifiRequired: false,
          iosAllowsCellularAccess: true,
        ),
      );

      final modelPath = model.file?.path;
      if (modelPath != null) {
        interpreter = await Interpreter.fromFile(File(modelPath));
        print('Modelo cargado desde: $modelPath');
      } else {
        print('Error cargando el modelo');
      }
    } catch (e) {
      print('Error loadModel: $e');
    }
  }

  Future<void> _initializeCameraWithPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      await _initializeCamera();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permiso de cámara denegado')),
        );
      }
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      backCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController!.initialize();

    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _captureAndPredict(),
    );

    setState(() {
      _isCameraInitialized = true;
      _isCameraActive = true;
    });
  }

  Future<ui.Image> resizeImage(ui.Image image, int width, int height) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
      paint,
    );
    final picture = recorder.endRecording();
    return picture.toImage(width, height);
  }

  Future<Uint8List> preprocessImage(File file) async {
    final bytes = await file.readAsBytes();

    final image = await decodeImageFromList(bytes);

    final resizedImage = await resizeImage(image, inputSize, inputSize);

    final byteData = await resizedImage.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    );
    final pixels = byteData!.buffer.asUint8List();

    final rgbBytes = Uint8List(inputSize * inputSize * channels);
    int j = 0;
    for (int i = 0; i < pixels.length; i += 4) {
      rgbBytes[j++] = pixels[i]; // R
      rgbBytes[j++] = pixels[i + 1]; // G
      rgbBytes[j++] = pixels[i + 2]; // B
    }

    return rgbBytes;
  }

  Future<void> _captureAndPredict() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;
    if (interpreter == null) return;

    try {
      final picture = await _cameraController!.takePicture();
      final file = File(picture.path);
      final inputBytes = await preprocessImage(file);

      const int height = 224;
      const int width = 224;
      const int channels = 3;

      List<List<List<List<int>>>> input = [
        List.generate(
          height,
          (y) => List.generate(width, (x) {
            int pixelIndex = (y * width + x) * channels;
            return [
              inputBytes[pixelIndex],
              inputBytes[pixelIndex + 1],
              inputBytes[pixelIndex + 2],
            ];
          }),
        ),
      ];

      final outputTensor = interpreter!.getOutputTensor(0);
      final outputShape = outputTensor.shape;
      final outputSize = outputShape.reduce((a, b) => a * b);
      final output = List.filled(outputSize, 0).reshape([1, outputSize]);

      interpreter!.run(input, output);

      int predIdx = 0;
      int maxVal = output[0][0];
      for (int i = 1; i < output[0].length; i++) {
        if (output[0][i] > maxVal) {
          maxVal = output[0][i];
          predIdx = i;
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Predicción: Clase ${classes[predIdx]}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Error en predicción: $e');
    }
  }

  void _stopCamera() {
    _timer?.cancel();
    _timer = null;
    _cameraController?.dispose();
    _cameraController = null;
    setState(() {
      _isCameraInitialized = false;
      _isCameraActive = false;
      _translatedText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6EC6E9),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                if (_isCameraActive) {
                  _stopCamera();
                } else {
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Volver',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    _isCameraInitialized
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CameraPreview(_cameraController!),
                        )
                        : Center(
                          child: ElevatedButton.icon(
                            onPressed: _initializeCameraWithPermission,
                            icon: const Icon(Icons.videocam),
                            label: const Text("Iniciar Traducción"),
                          ),
                        ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Text(
                _translatedText.isEmpty
                    ? 'Traducción en texto'
                    : _translatedText,
                style: const TextStyle(color: Colors.black, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            if (_isCameraActive)
              Center(
                child: ElevatedButton.icon(
                  onPressed: _stopCamera,
                  icon: const Icon(Icons.close),
                  label: const Text('Cancelar Cámara'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
