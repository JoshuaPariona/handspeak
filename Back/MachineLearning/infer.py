import os
import random
import json
import numpy as np
import cv2
import tensorflow as tf
import matplotlib.pyplot as plt

# --- Configuración ---
MODEL_PATH  = 'assets/model_quant_int8.tflite'
LABELS_PATH = 'assets/labels.json'
TEST_DIR    = os.path.join('data', 'test')
IMG_HEIGHT, IMG_WIDTH = 224, 224

# 1) Cargar intérprete TFLite
def load_interpreter(model_path):
    interpreter = tf.lite.Interpreter(model_path=model_path)
    interpreter.allocate_tensors()
    return interpreter

# 2) Preprocesar imagen
def preprocess_image(path):
    img = cv2.imread(path)
    if img is None:
        raise FileNotFoundError(f"No se pudo leer la imagen {path}")
    img_rgb     = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    img_resized = cv2.resize(img_rgb, (IMG_WIDTH, IMG_HEIGHT))
    img_input   = img_resized.astype(np.uint8)
    return np.expand_dims(img_input, axis=0), img_rgb

# 3) Cargar lista de etiquetas desde JSON
def load_labels(path):
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)

# 4) Obtener lista de todas las imágenes de test
def get_all_test_images(test_dir):
    all_imgs = []
    for cls in sorted(os.listdir(test_dir)):
        cls_dir = os.path.join(test_dir, cls)
        if not os.path.isdir(cls_dir):
            continue
        for fname in os.listdir(cls_dir):
            all_imgs.append((cls, os.path.join(cls_dir, fname)))
    return all_imgs

# 5) Ejecutar inferencia
def infer_image(interpreter, input_data):
    input_details  = interpreter.get_input_details()
    output_details = interpreter.get_output_details()
    interpreter.set_tensor(input_details[0]['index'], input_data)
    interpreter.invoke()
    return interpreter.get_tensor(output_details[0]['index'])

# --- Script principal ---
if __name__ == '__main__':
    # Cargar modelo y etiquetas
    interpreter = load_interpreter(MODEL_PATH)
    class_names = load_labels(LABELS_PATH)

    # Recopilar imágenes de test
    all_images = get_all_test_images(TEST_DIR)
    true_label, img_path = random.choice(all_images)
    print(f"Imagen seleccionada: {img_path} (Etiqueta real: {true_label})")

    # Preprocesar e inferir
    input_data, img_display = preprocess_image(img_path)
    output_data = infer_image(interpreter, input_data)

    # Decodificar predicción
    pred_idx        = int(np.argmax(output_data[0]))
    prob            = float(output_data[0, pred_idx]) / 255.0  # si tu modelo usa uint8, o sin dividir si ya es float
    predicted_class = class_names[pred_idx]

    print(f"Predicción: {predicted_class}, probabilidad = {prob:.3f}")

    # Mostrar imagen con título
    plt.figure(figsize=(4,4))
    plt.imshow(img_display)
    plt.title(f"Real: {true_label}  |  Pred: {predicted_class} ({prob:.2f})")
    plt.axis('off')
    plt.show()
