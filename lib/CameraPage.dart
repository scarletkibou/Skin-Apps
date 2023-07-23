import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dataPage.dart';
import 'homepage.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? _pickedImage;
  String _predictionResult = "";
  String _ResultName = "";
  bool _isPredicting = false;
  bool _showGoToAnotherPageButton = false; // New state variable

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
        _isPredicting = true;
      });
      Map<String, dynamic> prediction = await makePrediction(imageFile);
      print(prediction);
      setState(() {
        _predictionResult =
            "${prediction['class']},${prediction['confidence']}";
        _isPredicting = false;
      });
    }
  }

  Widget _buildPredictionResult() {
    if (_predictionResult.isEmpty) {
      return Container();
    }
    List<String> predictionList = _predictionResult.split(',');
    String prediction = predictionList[0].trim();
    String confidence = predictionList[1].trim();
    _ResultName = prediction;
    int confidenceCheck = (double.parse(confidence)).round();
    if (confidenceCheck > 50) {
      _showGoToAnotherPageButton = true;
      return RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 20, color: Colors.black),
          children: [
            TextSpan(
              text: 'Prediction: ',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            TextSpan(
              text: prediction,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
            ),
            TextSpan(
              text: ',    Confidence: ',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            TextSpan(
              text: confidence + "%",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      );
    } else {
      _showGoToAnotherPageButton = false;
      return RichText(
        text: const TextSpan(
          style: TextStyle(fontSize: 20, color: Colors.black),
          children: [
            TextSpan(
              text:
                  'Confidence is lower than a half, make sure you input the right picture or follow the right instruction',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(
                border:
                    Border.all(color: Color.fromARGB(255, 3, 4, 4), width: 0.5),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: _pickedImage != null
                  ? Image.file(
                      _pickedImage!,
                      height: 200,
                      width: 200,
                    )
                  : const Icon(
                      Icons.image_search,
                      size: 200,
                      color: Color(0xFF398378),
                    ),
            ),
            SizedBox(height: 20),
            _isPredicting
                ? SpinKitWaveSpinner(color: Color(0xFF398378), size: 50)
                : _buildPredictionResult(),
            SizedBox(height: 20),
            _showGoToAnotherPageButton // Show the button based on the state
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => dataPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF398378),
                      padding: EdgeInsets.symmetric(vertical: 20),
                    ),
                    child: Text('See $_ResultName Details'),
                  )
                : Container(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _pickImage(ImageSource.gallery);
                    },
                    child: Text('Pick Image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF398378),
                      padding: EdgeInsets.symmetric(vertical: 20),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _pickImage(ImageSource.camera);
                    },
                    child: Text('Take Photo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF398378),
                      padding: EdgeInsets.symmetric(vertical: 20),
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
