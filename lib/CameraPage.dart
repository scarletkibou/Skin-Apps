import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? _pickedImage;
  String _predictionResult = "";

  final String cloudFunctionUrl =
      'https://us-central1-skin-apps.cloudfunctions.net/predict_x';

  Future<Map<String, dynamic>> makePrediction(File imageFile) async {
    var request = http.MultipartRequest('POST', Uri.parse(cloudFunctionUrl));
    request.files
        .add(await http.MultipartFile.fromPath('file', imageFile.path));

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    return jsonDecode(responseBody);
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      setState(() {
        _pickedImage = imageFile;
      });
      Map<String, dynamic> prediction = await makePrediction(imageFile);
      print(prediction);
      setState(() {
        _predictionResult =
            "Prediction: ${prediction['class']}, Confidence: ${prediction['confidence']}%";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _pickedImage != null
                ? Image.file(
                    _pickedImage!,
                    height: 200,
                    width: 200,
                  )
                : SizedBox.shrink(),
            SizedBox(height: 20),
            Text(_predictionResult),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    _pickImage(ImageSource.gallery); // Pick from gallery
                  },
                  child: Text('Pick Image'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(
                      color: Colors.red,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                OutlinedButton(
                  onPressed: () {
                    _pickImage(ImageSource.camera); // Take a photo
                  },
                  child: Text('Take Photo'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green,
                    side: BorderSide(
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
