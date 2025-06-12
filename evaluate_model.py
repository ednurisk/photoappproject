import os
import numpy as np
import tensorflow as tf
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from sklearn.metrics import classification_report, confusion_matrix
import json
from tqdm import tqdm

# Yollar
BASE_DIR = r"C:\Users\EdaNurIsik\Desktop\Lung-Cancer-Prediction-using-CNN-and-Transfer-Learning-main\dataset"
MODEL_PATH = os.path.join(BASE_DIR, "best_model.keras")
CLASS_INDEX_PATH = os.path.join(BASE_DIR, "class_indices.json")
TEST_PATH = os.path.join(BASE_DIR, "test")

# Görsel boyutu
IMAGE_SIZE = (350, 350)
BATCH_SIZE = 8

# Model yükle
model = tf.keras.models.load_model(MODEL_PATH)

# Sınıf isimlerini yükle
with open(CLASS_INDEX_PATH, 'r') as f:
    idx_to_class = json.load(f)

# Anahtarları sayısal sıraya göre sırala
class_names = [idx_to_class[str(i)] for i in range(len(idx_to_class))]

# Data Generator
test_datagen = ImageDataGenerator(rescale=1./255)

test_generator = test_datagen.flow_from_directory(
    TEST_PATH,
    target_size=IMAGE_SIZE,
    batch_size=1,
    class_mode='categorical',
    shuffle=False
)

print("Test verisi üzerinde tahmin yapılıyor...")
predictions = model.predict(test_generator, steps=len(test_generator), verbose=1)
y_pred = np.argmax(predictions, axis=1)
y_true = test_generator.classes

# Rapor
print("\nSınıf Bazlı Değerlendirme Raporu:")
print(classification_report(y_true, y_pred, target_names=test_generator.class_indices.keys()))

# Karışıklık Matrisi
print("Karışıklık Matrisi:")
print(confusion_matrix(y_true, y_pred))
