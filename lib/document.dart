import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ImageProcessingPage extends StatefulWidget {
  @override
  _ImageProcessingPageState createState() => _ImageProcessingPageState();
}

class _ImageProcessingPageState extends State<ImageProcessingPage> {
  File? _selectedImage;
  Uint8List? _processedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _processedImage = null;
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen bir görsel seçin')),
      );
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      //Uri.parse('http://172.20.33.167:5000/process-image')
      //Uri.parse('http://172.20.34.143:5000/process-image')
      //Uri.parse('http://192.168.0.27:5000/process-image'),
      //Uri.parse('http://192.168.102.172:8080//process'),
      Uri.parse('http://192.168.71.172:5050//process'),
    );

    request.files.add(
      await http.MultipartFile.fromPath('image', _selectedImage!.path),
    );

    var response = await request.send();
    if (response.statusCode == 200) {
      var processedBytes = await response.stream.toBytes();
      setState(() {
        _processedImage = processedBytes;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Görsel işleme başarısız oldu!')),
      );
    }
  }

/*
  Future<void> _saveImageToGallery() async {
    if (_processedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kaydedilecek bir işlenmiş görsel yok!')),
      );
      return;
    }

    var status = await Permission.storage.request();
    if (status.isGranted) {
      final result = await ImageGallerySaver.saveImage(
        _processedImage!,
        name: "processed_image_${DateTime.now().millisecondsSinceEpoch}",
      );

      if (result['isSuccess']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Görsel galeriye kaydedildi')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Görsel kaydedilemedi!')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Depolama izni reddedildi!')),
      );
    }
  }

*/

  Future<void> _saveImageToPicturesFolder() async {
    if (_processedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kaydedilecek bir işlenmiş görsel yok!')),
      );
      return;
    }

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final imagePath =
          '/storage/emulated/0/Documents/photos/processed_image_$timestamp.png';
      final file = File(imagePath);
      await file.writeAsBytes(_processedImage!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Görsel kaydedildi: $imagePath')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Görsel kaydedilemedi: $e')),
      );
    }
  }

  Future<void> _saveAsPDF() async {
    if (_processedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF oluşturmak için işlenmiş bir görsel yok!')),
      );
      return;
    }

    try {
      final pdf = pw.Document();
      final image = pw.MemoryImage(_processedImage!);

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Center(
            child: pw.Image(image),
          ),
        ),
      );

      final directory = await getExternalStorageDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final pdfPath =
          '/storage/emulated/0/Documents/processed_image_$timestamp.pdf';
      final file = File(pdfPath);
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF kaydedildi: $pdfPath')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF kaydedilemedi: $e')),
      );
    }
  }

  Future<void> _showSaveOptionsDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Kaydetme Seçenekleri'),
          content: Text('Lütfen kaydetme yöntemini seçin.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _saveImageToPicturesFolder();
              },
              child: Text('Galeride Kaydet'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _saveAsPDF();
              },
              child: Text('PDF Olarak Kaydet'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Tarayıcı'),
        centerTitle: true,
        backgroundColor: Colors.purple[200],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _selectedImage != null
                ? Image.file(_selectedImage!, height: 200)
                : Container(
                    height: 200,
                    color: const Color.fromARGB(255, 226, 199, 231),
                    child: Center(child: Text('Bir görsel seçin')),
                  ),
            SizedBox(height: 16),
            _processedImage != null
                ? Image.memory(_processedImage!, height: 200)
                : Container(
                    height: 200,
                    color: const Color.fromARGB(255, 226, 199, 231),
                    child: Center(
                        child: Text('İşlenmiş görsel burada gösterilecek')),
                  ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Görsel Seç'),
                ),
                ElevatedButton(
                  onPressed: _uploadImage,
                  child: Text('İşle ve Gönder'),
                ),
                ElevatedButton(
                  onPressed: _showSaveOptionsDialog,
                  child: Text('Kaydet'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

