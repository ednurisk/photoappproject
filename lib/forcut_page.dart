import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'cropped_image.dart';

class CutPage extends StatefulWidget {
  const CutPage({super.key});
  @override
  State<CutPage> createState() => _CutPageState();
}

class _CutPageState extends State<CutPage> {
  void pickImage(bool pickGalleryImage) async {
    XFile? image;
    final picker = ImagePicker();

    if (pickGalleryImage) {
      image = await picker.pickImage(source: ImageSource.gallery);
    } else {
      image = await picker.pickImage(source: ImageSource.camera);
    }

    if (image != null) {
      final croppedImage = await cropImages(image);

      if (!mounted || croppedImage == null) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CroppedImages(
            image: croppedImage,
          ),
        ),
      );
    }
  }

  Future<CroppedFile?> cropImages(XFile image) async {
    return await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio7x5,
        CropAspectRatioPreset.ratio16x9,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.purple[200],
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fotoğraf Kırpıcı'),
        centerTitle: true,
        backgroundColor: Colors.purple[200],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MaterialButton(
              color: Colors.purple[200],
              textColor: Colors.white,
              padding: const EdgeInsets.all(20),
              onPressed: () {
                pickImage(true);
              },
              child: Text('Resmi Galeriden Seç'),
            ),
            SizedBox(height: 10),
            MaterialButton(
              color: Colors.purple[200],
              textColor: Colors.white,
              padding: const EdgeInsets.all(20),
              onPressed: () {
                pickImage(false);
              },
              child: Text('Kamerayı Kullan'),
            ),
          ],
        ),
      ),
    );
  }
}
