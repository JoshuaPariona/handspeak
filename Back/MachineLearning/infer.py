import os
import random
import numpy as np
import cv2
import tensorflow as tf
import matplotlib.pyplot as plt

MODEL_PATH = 'assets/model_quant_int8.tflite'  
TEST_DIR = os.path.join('data', 'test')    
IMG_HEIGHT, IMG_WIDTH = 224, 224

# 1) Cargar intérprete TFLite
def load_interpreter(model_path):
    interpreter = tf.lite.Interpreter(model_path=model_path)
    interpreter.allocate_tensors()
    return interpreter

# 2) Preprocesar imagen para modelo int8
def preprocess_image(path):
    img = cv2.imread(path)
    if img is None:
        raise FileNotFoundError(f"No se pudo leer la imagen {path}")
    img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    img_resized = cv2.resize(img_rgb, (IMG_WIDTH, IMG_HEIGHT))
    img_input = img_resized.astype(np.uint8)
    return np.expand_dims(img_input, axis=0), img_rgb

# 3) Obtener mapeo de clases
def get_class_names(test_dir):
    return sorted([d for d in os.listdir(test_dir) if os.path.isdir(os.path.join(test_dir, d))])

# 4) Recorrer test_dir para obtener lista de archivos
def get_all_test_images(test_dir):
    all_imgs = []
    for cls in get_class_names(test_dir):
        cls_dir = os.path.join(test_dir, cls)
        for fname in os.listdir(cls_dir):
            path = os.path.join(cls_dir, fname)
            all_imgs.append((cls, path))
    return all_imgs

# 5) Ejecutar inferencia
def infer_image(interpreter, input_data):
    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()
    interpreter.set_tensor(input_details[0]['index'], input_data)
    interpreter.invoke()
    return interpreter.get_tensor(output_details[0]['index'])

if __name__ == '__main__':
    # Cargar intérprete TFLite
    interpreter = load_interpreter(MODEL_PATH)

    # Obtener clases y lista de imágenes de test
    class_names = get_class_names(TEST_DIR)
    all_images = get_all_test_images(TEST_DIR)

    # Elegir imagen aleatoria
    true_label, img_path = random.choice(all_images)
    print(f"Imagen seleccionada: {img_path} (Etiqueta real: {true_label})")

    # Preprocesar e inferir
    input_data, img_display = preprocess_image(img_path)
    output_data = infer_image(interpreter, input_data)

    # Interpretar resultado
    pred_idx = int(np.argmax(output_data[0]))
    prob = float(output_data[0, pred_idx])
    predicted_class = class_names[pred_idx]

    print(f"Predicción: {predicted_class}, probabilidad = {prob:.3f}")

    plt.figure(figsize=(4,4))
    plt.imshow(img_display)
    plt.title(f"Real: {true_label}  |  Pred: {predicted_class} ({prob:.2f})")
    plt.axis('off')
    plt.show()
    