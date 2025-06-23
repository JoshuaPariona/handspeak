import os
import numpy as np
import matplotlib.pyplot as plt
from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing.image import ImageDataGenerator

test_dir = os.path.join('data', 'test')
batch_size = 32
img_height, img_width = 224, 224

datagen = ImageDataGenerator(rescale=1/255.0)
test_gen = datagen.flow_from_directory(
    test_dir,
    target_size=(img_height, img_width),
    batch_size=batch_size,
    class_mode='categorical',
    shuffle=False  
)

model = load_model('best.h5')

loss, acc = model.evaluate(test_gen)

pred_probs = model.predict(test_gen)
pred_labels = np.argmax(pred_probs, axis=1)
true_labels = test_gen.classes
class_names = list(test_gen.class_indices.keys())

cm = confusion_matrix(true_labels, pred_labels)

disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=class_names)

disp.plot(cmap=plt.cm.Blues, xticks_rotation=90)
plt.tight_layout()
plt.savefig('confusion_matrix.png')
plt.show()

