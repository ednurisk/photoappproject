import os
import shutil
import random
from sklearn.model_selection import train_test_split

# Kaynak ve hedef klasör yolları
ORIGINAL_PATH = r"C:\Users\EdaNurIsik\Desktop\Lung-Cancer-Prediction-using-CNN-and-Transfer-Learning-main\dataset\train"
TARGET_BASE = r"C:\Users\EdaNurIsik\Desktop\Lung-Cancer-Prediction-using-CNN-and-Transfer-Learning-main\dataset"
NEW_TRAIN_PATH = os.path.join(TARGET_BASE, "train_85")
NEW_VALID_PATH = os.path.join(TARGET_BASE, "valid_15")

# Eğitim/validasyon oranı
TRAIN_RATIO = 0.85

# Hedef klasörleri temizle
for folder in [NEW_TRAIN_PATH, NEW_VALID_PATH]:
    if os.path.exists(folder):
        shutil.rmtree(folder)
    os.makedirs(folder)

# Sınıfları oku
class_names = os.listdir(ORIGINAL_PATH)

# Her sınıf için ayrı ayrı verileri böl ve kopyala
for class_name in class_names:
    class_dir = os.path.join(ORIGINAL_PATH, class_name)
    images = os.listdir(class_dir)
    train_imgs, valid_imgs = train_test_split(images, train_size=TRAIN_RATIO, random_state=42)

    # Hedef sınıf klasörlerini oluştur
    train_class_dir = os.path.join(NEW_TRAIN_PATH, class_name)
    valid_class_dir = os.path.join(NEW_VALID_PATH, class_name)
    os.makedirs(train_class_dir)
    os.makedirs(valid_class_dir)

    # Dosyaları taşı
    for img in train_imgs:
        shutil.copy(os.path.join(class_dir, img), os.path.join(train_class_dir, img))

    for img in valid_imgs:
        shutil.copy(os.path.join(class_dir, img), os.path.join(valid_class_dir, img))

print("✅ Veriler %85 eğitim / %15 validasyon olarak ayrıldı.")
