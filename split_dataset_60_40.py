import os
import shutil
import random

# Ayarlar
BASE_PATH = r"C:\Users\EdaNurIsik\Desktop\Lung-Cancer-Prediction-using-CNN-and-Transfer-Learning-main\dataset"
TRAIN_PATH = os.path.join(BASE_PATH, 'train')
VALID_PATH = os.path.join(BASE_PATH, 'valid')
MERGED_PATH = os.path.join(BASE_PATH, 'merged_temp')  # Geçici birleşim klasörü
NEW_TRAIN_PATH = os.path.join(BASE_PATH, 'train_new')
NEW_VALID_PATH = os.path.join(BASE_PATH, 'valid_new')
RATIO = 0.6  # %60 train, %40 valid

# Geçici klasör oluştur (merge)
if os.path.exists(MERGED_PATH):
    shutil.rmtree(MERGED_PATH)
os.makedirs(MERGED_PATH, exist_ok=True)

# train ve valid klasörlerini birleştir
for folder in [TRAIN_PATH, VALID_PATH]:
    for class_name in os.listdir(folder):
        class_path = os.path.join(folder, class_name)
        merged_class_path = os.path.join(MERGED_PATH, class_name)
        os.makedirs(merged_class_path, exist_ok=True)
        for img in os.listdir(class_path):
            src = os.path.join(class_path, img)
            dst = os.path.join(merged_class_path, img)
            shutil.copy(src, dst)

# Yeni train/valid klasörleri oluştur
for path in [NEW_TRAIN_PATH, NEW_VALID_PATH]:
    if os.path.exists(path):
        shutil.rmtree(path)
    os.makedirs(path)

# %60 - %40 oranında böl
for class_name in os.listdir(MERGED_PATH):
    class_path = os.path.join(MERGED_PATH, class_name)
    images = os.listdir(class_path)
    random.shuffle(images)

    train_count = int(len(images) * RATIO)
    train_images = images[:train_count]
    valid_images = images[train_count:]

    # Klasörleri oluştur
    os.makedirs(os.path.join(NEW_TRAIN_PATH, class_name), exist_ok=True)
    os.makedirs(os.path.join(NEW_VALID_PATH, class_name), exist_ok=True)

    for img in train_images:
        shutil.copy(os.path.join(class_path, img), os.path.join(NEW_TRAIN_PATH, class_name, img))
    for img in valid_images:
        shutil.copy(os.path.join(class_path, img), os.path.join(NEW_VALID_PATH, class_name, img))

print("Yeni veri bölme tamamlandı: %60 train - %40 valid")

# (İsteğe bağlı) Geçici klasörü sil
shutil.rmtree(MERGED_PATH)
