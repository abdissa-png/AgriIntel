import 'dart:convert';
import 'dart:io';
import 'package:crop_recommendation/dataprovider/mlprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

class DamageDetection extends StatefulWidget {
  @override
  _DamageDetectionState createState() => _DamageDetectionState();
}

class _DamageDetectionState extends State<DamageDetection> {
  File? _image;

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _uploadImage() async {
    if (_image == null) {
      return;
    }

    try {
      Map<String, dynamic> response =
          await imageRecognition(_image!, "CropDamage");
      String tableContent = '';
      response['prediction'].forEach((key, value) {
        tableContent += '$key: $value\n';
      });

      // Display the server response in a dialog with the formatted table content
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Server Response"),
            content: Text(tableContent),
            actions: [
              TextButton(
                onPressed: () {
                  context.go("/home");
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (error) {
      print("Error sending data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Upload App"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text("No image selected")
                : Image.file(
                    _image!,
                    height: 150,
                  ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _getImage(ImageSource.gallery),
                  child: Text("Pick Image"),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => _getImage(ImageSource.camera),
                  child: Text("Take Picture"),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
