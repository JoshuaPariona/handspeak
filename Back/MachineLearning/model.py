import tensorflow as tf
from tensorflow.keras import layers, Model


def build_model(input_shape=(224, 224, 3), n_classes=26):

    base_model = tf.keras.applications.MobileNetV2(
        input_shape=input_shape,
        include_top=False,
        weights='imagenet'
    )
    base_model.trainable = False

    x = layers.GlobalAveragePooling2D()(base_model.output)
    x = layers.Dropout(0.2)(x)
    outputs = layers.Dense(n_classes, activation='softmax')(x)

    model = Model(inputs=base_model.input, outputs=outputs, name='signs_classifier')
    return model


if __name__ == '__main__':
    model = build_model()
    model.summary()
