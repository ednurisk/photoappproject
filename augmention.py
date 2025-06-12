import os
import cv2
import numpy as np
from PIL import Image
from albumentations import (
    HorizontalFlip, RandomBrightnessContrast, Rotate, ShiftScaleRotate,
    Blur, GaussNoise, CLAHE, Resize, OneOf, Compose
)
from albumentations.pytorch import ToTensorV2

# Hangi sınıflara augmentasyon yapılacak?
target_classes = ['adenocarcinoma', 'large.cell.carcinoma']
data_root = 'dataset/train'
augment_per_image = 5  # Daha fazla varyasyon

# Augmentasyon pipeline'ı
augment = Compose([
    HorizontalFlip(p=0.5),
    RandomBrightnessContrast(p=0.5),
    ShiftScaleRotate(shift_limit=0.0625, scale_limit=0.1, rotate_limit=15, p=0.7),
    OneOf([
        Blur(blur_limit=3),
        GaussNoise(var_limit=(10.0, 50.0))
    ], p=0.3),
    CLAHE(p=0.3),  # Kontrast iyileştirme
    Resize(350, 350)  # Modelin giriş boyutuna uygun hale getir
])

# Kaydetme işlemi
for cls in target_classes:
    class_dir = os.path.join(data_root, cls)
    images = [f for f in os.listdir(class_dir) if f.lower().endswith(('.png', '.jpg', '.jpeg'))]

    for img_name in images:
        img_path = os.path.join(class_dir, img_name)
        image = np.array(Image.open(img_path).convert("RGB"))

        for i in range(augment_per_image):
            augmented = augment(image=image)
            aug_image = augmented['image']
            new_name = f"{os.path.splitext(img_name)[0]}_aug{i+1}.jpg"
            cv2.imwrite(os.path.join(class_dir, new_name), cv2.cvtColor(aug_image, cv2.COLOR_RGB2BGR))

print("Gelişmiş veri artırımı tamamlandı ✅")
