import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:gallery_saver/gallery_saver.dart';

class CroppedImages extends StatefulWidget {
  final CroppedFile image;

  const CroppedImages({super.key, required this.image});

  @override
  State<CroppedImages> createState() => _CroppedImagesState();
}

class _CroppedImagesState extends State<CroppedImages> {
  Future<void> saveCroppedImage() async {
    final file = File(widget.image.path);

    // Galeriye kaydet
    await GallerySaver.saveImage(file.path);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Fotoğraf başarıyla kaydedildi!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fotoğrafı Kırp'),
        centerTitle: true,
        backgroundColor: Colors.purple[200],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveCroppedImage,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: InteractiveViewer(
            child: Image.file(File(widget.image.path)),
          ),
        ),
      ),
    );
  }
}
