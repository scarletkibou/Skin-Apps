import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  ImagePicker picker = ImagePicker();
  XFile? image;

  Future<http.Response> fetchAlbum() {
    return http.get(Uri.parse(
        'https://us-central1-skin-apps.cloudfunctions.net/predict_x'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Picker from Gallery"),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                XFile? pickedImage =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedImage != null) {
                  setState(() {
                    image = pickedImage;
                  });
                }
              },
              child: Text("Pick Image"),
            ),
            image == null
                ? Container() // If no image is selected, show an empty container.
                : Image.file(File(image!.path)),
          ],
        ),
      ),
    );
  }
}
