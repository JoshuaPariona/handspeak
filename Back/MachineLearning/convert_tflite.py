import tensorflow as tf
from tensorflow.keras.preprocessing.image import ImageDataGenerator

model = tf.keras.models.load_model('best.h5')

converter = tf.lite.TFLiteConverter.from_keras_model(model)

converter.optimizations = [tf.lite.Optimize.DEFAULT]
converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS_INT8]
converter.inference_input_type = tf.uint8
converter.inference_output_type = tf.uint8

def representative_data_gen():
    datagen = ImageDataGenerator(rescale=1/255.0)
    gen = datagen.flow_from_directory(
        'data/train',
        target_size=(224,224),
        batch_size=1,
        class_mode=None,
        shuffle=True
    )
    for i in range(100): 
        data = next(gen)
        yield [data]
converter.representative_dataset = representative_data_gen

tflite_model = converter.convert()

tflite_path = 'assets/model_quant_int8.tflite'
with open(tflite_path, 'wb') as f:
    f.write(tflite_model)

