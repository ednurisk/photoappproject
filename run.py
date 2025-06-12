import tensorflow as tf
import os
import numpy as np
from tkinter import filedialog, Tk, Label, Button
from tensorflow.keras.preprocessing.image import load_img, img_to_array
from PIL import Image, ImageTk

# Yapılandırmalar
IMAGE_SIZE = (350, 350)
CLASS_NAMES = ['Adenocarcinoma', 'Large Cell Carcinoma', 'Normal', 'Squamous Cell Carcinoma']
MODEL_PATH = r"C:\Users\EdaNurIsik\Desktop\Lung-Cancer-Prediction-using-CNN-and-Transfer-Learning-main\best_model.keras"

# Modeli yükle
model = tf.keras.models.load_model(MODEL_PATH)

# Tahmin fonksiyonu
def predict_image(image_path):
    image = load_img(image_path, target_size=IMAGE_SIZE)
    image_array = img_to_array(image) / 255.0
    image_array = np.expand_dims(image_array, axis=0)
    predictions = model.predict(image_array)
    class_index = np.argmax(predictions)
    class_name = CLASS_NAMES[class_index]
    confidence = predictions[0][class_index] * 100
    return class_name, confidence

# Arayüz oluştur
def show_gui():
    def select_image():
        file_path = filedialog.askopenfilename(
            title="Bir Görsel Seçin",
            filetypes=[("Image files", "*.jpg *.jpeg *.png *.bmp *.tif *.tiff")]
        )
        if file_path:
            class_name, confidence = predict_image(file_path)

            # Görseli göster
            img = Image.open(file_path).resize((300, 300))
            tk_img = ImageTk.PhotoImage(img)
            image_label.config(image=tk_img)
            image_label.image = tk_img  # referansı tut

            # Tahmin sonuçlarını göster
            result_label.config(text=f"Tahmin: {class_name}\nGüven: {confidence:.2f}%")

    # Ana pencere
    root = Tk()
    root.title("Akciğer Kanseri Tahmin Sistemi")
    root.geometry("400x500")
    root.resizable(False, False)

    # Başlık
    title_label = Label(root, text="Akciğer Kanseri Görüntü Tahmini", font=("Arial", 14, "bold"))
    title_label.pack(pady=10)

    # Görsel alanı
    image_label = Label(root)
    image_label.pack(pady=10)

    # Tahmin sonucu etiketi
    result_label = Label(root, text="", font=("Arial", 12))
    result_label.pack(pady=10)

    # Görsel seçme butonu
    select_button = Button(root, text="Görsel Seç", command=select_image, font=("Arial", 12), width=20)
    select_button.pack(pady=20)

    # Arayüzü başlat
    root.mainloop()

# Çalıştır
if __name__ == "__main__":
    show_gui()
