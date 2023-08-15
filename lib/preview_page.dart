import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_r/temp_camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_r/DiseasePage.dart';
import 'package:uuid/uuid.dart';
import 'CameraPage.dart';

class PreviewPage extends StatefulWidget {
  final XFile picture;

  PreviewPage({Key? key, required this.picture}) : super(key: key);

  @override
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  bool _isPredicting = false;
  String _predictionResult = "";
  String _resultName = "";
  bool _showContinueButton = false;

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

  Future<void> predictImage() async {
    setState(() {
      _isPredicting = true;
    });

    Map<String, dynamic> prediction =
        await makePrediction(File(widget.picture.path));

    setState(() {
      _predictionResult = "${prediction['class']},${prediction['confidence']}";
      _isPredicting = false;
    });

    List<String> predictionList = _predictionResult.split(',');
    String predictionValue = predictionList[0].trim();

    if (predictionValue.isNotEmpty) {
      setState(() {
        _resultName = predictionValue;
        _showContinueButton = true;
      });
    }
  }

  void continueToNextPage() {
    if (_resultName.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DiseasePage(diseaseName: _resultName),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(File(widget.picture.path),
                fit: BoxFit.cover, width: 150),
            const SizedBox(height: 200),
            const SizedBox(height: 10),
            _isPredicting
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      predictImage();
                    },
                    child: Text('Predict'),
                  ),
            const SizedBox(height: 20),
            _predictionResult.isNotEmpty
                ? _showContinueButton
                    ? ElevatedButton(
                        onPressed: () {
                          continueToNextPage();
                        },
                        child: Text('Continue to $_resultName'),
                      )
                    : Text(
                        'Prediction: $_predictionResult',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                : Container(),
          ],
        ),
      ),
    );
  }
}
