import tensorflow as tf
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, GlobalAveragePooling2D
from tensorflow.keras.callbacks import ReduceLROnPlateau, EarlyStopping, ModelCheckpoint
import os
import json

# Dataset path
DATASET_PATH = r"C:\Users\EdaNurIsik\Desktop\Lung-Cancer-Prediction-using-CNN-and-Transfer-Learning-main\dataset"
TRAIN_PATH = os.path.join(DATASET_PATH, "train")
VALID_PATH = os.path.join(DATASET_PATH, "valid")

# Image config
IMAGE_SIZE = (350, 350)
BATCH_SIZE = 8
EPOCHS = 50
MODEL_SAVE_PATH = os.path.join(DATASET_PATH, 'best_model.keras')
CLASS_INDEX_PATH = os.path.join(DATASET_PATH, 'class_indices.json')

# Data Generators
train_datagen = ImageDataGenerator(rescale=1./255, horizontal_flip=True)
valid_datagen = ImageDataGenerator(rescale=1./255)

train_generator = train_datagen.flow_from_directory(
    TRAIN_PATH,
    target_size=IMAGE_SIZE,
    batch_size=BATCH_SIZE,
    class_mode='categorical'
)

valid_generator = valid_datagen.flow_from_directory(
    VALID_PATH,
    target_size=IMAGE_SIZE,
    batch_size=BATCH_SIZE,
    class_mode='categorical'
)

# Save class indices
class_indices = train_generator.class_indices  # e.g., {'adenocarcinoma': 0, ...}
idx_to_class = {v: k for k, v in class_indices.items()}  # {'0': 'adenocarcinoma', ...}
with open(CLASS_INDEX_PATH, 'w') as f:
    json.dump(idx_to_class, f)
print("Sınıf sıralaması kaydedildi:", idx_to_class)

# Callbacks
callbacks = [
    ReduceLROnPlateau(monitor='loss', patience=5, verbose=2, factor=0.5, min_lr=1e-6),
    EarlyStopping(monitor='loss', patience=6, verbose=2),
    ModelCheckpoint(filepath=MODEL_SAVE_PATH, verbose=2, save_best_only=True)
]

# Pretrained model (Xception)
base_model = tf.keras.applications.Xception(weights='imagenet', include_top=False, input_shape=(*IMAGE_SIZE, 3))
base_model.trainable = False

model = Sequential([
    base_model,
    GlobalAveragePooling2D(),
    Dense(len(class_indices), activation='softmax')
])

model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])

# Train model
history = model.fit(
    train_generator,
    steps_per_epoch=len(train_generator),
    epochs=EPOCHS,
    validation_data=valid_generator,
    validation_steps=len(valid_generator),
    callbacks=callbacks
)

# Print best validation accuracy
best_val_acc = max(history.history['val_accuracy'])
print(f"Best validation accuracy: {best_val_acc * 100:.2f}%")
