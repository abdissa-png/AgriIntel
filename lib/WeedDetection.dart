import 'dart:convert';
import 'dart:io';
import 'package:crop_recommendation/dataprovider/mlprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

class WeedDetection extends StatefulWidget {
  @override
  _WeedDetectionState createState() => _WeedDetectionState();
}

class _WeedDetectionState extends State<WeedDetection> {
  File? _image;
  bool _isLoading = false;

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _uploadImage() async {
      setState(() {
      _isLoading = true;
    });
    if (_image == null) {
      return;
    }

    try {
      Map<String, dynamic> response =
          await imageRecognition(_image!, "WeedDetection");
      String tableContent = '';
      response.forEach((key, value) {
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
    finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weed detection"),
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
            if (_isLoading)
                Center(child: CircularProgressIndicator())
              else ...[
            _image == null
                ? Row( mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("No image selected"),Icon(Icons.photo_library)])
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
        ]),
      ),
    );
  }
}
