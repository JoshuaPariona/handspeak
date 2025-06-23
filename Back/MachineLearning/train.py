import os
import json
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.callbacks import ModelCheckpoint, EarlyStopping, ReduceLROnPlateau
from model import build_model

IMG_HEIGHT, IMG_WIDTH = 224, 224
BATCH_SIZE = 32
EPOCHS = 10
TRAIN_DIR = os.path.join('data', 'train')
VAL_DIR   = os.path.join('data', 'val')

train_datagen = ImageDataGenerator(
    rescale=1/255.0,
    rotation_range=15,
    width_shift_range=0.1,
    height_shift_range=0.1,
    shear_range=10,
    zoom_range=0.2,
    brightness_range=[0.8,1.2],
    fill_mode='nearest'
)
val_datagen = ImageDataGenerator(rescale=1/255.0)

global_train_gen = train_datagen.flow_from_directory(
    TRAIN_DIR,
    target_size=(IMG_HEIGHT, IMG_WIDTH),
    batch_size=BATCH_SIZE,
    class_mode='categorical'
)
num_classes = global_train_gen.num_classes
print(f"Número de clases detectadas en train: {num_classes}")

global_val_gen = val_datagen.flow_from_directory(
    VAL_DIR,
    target_size=(IMG_HEIGHT, IMG_WIDTH),
    batch_size=BATCH_SIZE,
    class_mode='categorical'
)

model = build_model(input_shape=(IMG_HEIGHT, IMG_WIDTH, 3), n_classes=num_classes)
model.compile(
    optimizer='adam',
    loss='categorical_crossentropy',
    metrics=['accuracy']
)

callbacks = [
    ModelCheckpoint('best.h5', monitor='val_accuracy', save_best_only=True, verbose=1),
    ReduceLROnPlateau(monitor='val_loss', factor=0.5, patience=3, verbose=1),
    EarlyStopping(monitor='val_accuracy', patience=5, restore_best_weights=True, verbose=1)
]

history = model.fit(
    global_train_gen,
    validation_data=global_val_gen,
    epochs=EPOCHS,
    callbacks=callbacks
)

with open('history.json', 'w') as f:
    json.dump(history.history, f)

