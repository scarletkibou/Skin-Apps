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

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? _pickedImage;

  String _predictionResult = "";
  String _ResultName = "";
  bool _isPredicting = false;
  var uuid = Uuid();
  bool _showGoToAnotherPageButton = false;

  final String cloudFunctionUrl =
      'https://us-central1-skin-apps.cloudfunctions.net/predict_x';
  @override
  void initState() {
    super.initState();
    final storage = FirebaseStorage.instance;
  }

  Future<Map<String, dynamic>> makePrediction(File imageFile) async {
    var request = http.MultipartRequest('POST', Uri.parse(cloudFunctionUrl));
    request.files
        .add(await http.MultipartFile.fromPath('file', imageFile.path));

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    return jsonDecode(responseBody);
  }

  Future uploadFile(File imageFile) async {
    var name = uuid.v4();
    final pathSaved = 'Saved_Photo/$name';
    final storageRef = FirebaseStorage.instance.ref();
    final file = File(imageFile.path);
    final ref = FirebaseStorage.instance.ref().child(pathSaved);
    ref.putFile(file);
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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ConfirmDialog(
            onUserResponse: (bool userConfirmed) {
              if (userConfirmed) {
                uploadFile(_pickedImage!);
                Navigator.pop(context, false);
              } else {
                Navigator.pop(context, false);
              }
            },
          );
        },
      );
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
    if (confidenceCheck > 45) {
      _showGoToAnotherPageButton = true;
      return RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 25, color: Colors.black),
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
              text: '\nConfidence: ',
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
          style: TextStyle(fontSize: 20),
          children: [
            TextSpan(
              text:
                  'Confidence is too low , make sure you input the right image or follow the right instruction',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
                border: Border.all(
                    color: Color.fromRGBO(214, 203, 193, 1), width: 0.5),
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
                      color: Color.fromRGBO(214, 203, 193, 1),
                    ),
            ),
            SizedBox(height: 20),
            _isPredicting
                ? SpinKitWaveSpinner(color: Color(0xFF398378), size: 50)
                : _buildPredictionResult(),
            SizedBox(height: 20),
            _showGoToAnotherPageButton
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DiseasePage(
                                  Disease_name: _ResultName,
                                )),
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
                    onPressed: () async {
                      await availableCameras().then((value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => TempCamera(cameras: value))));
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

class ConfirmDialog extends StatelessWidget {
  final Function(bool) onUserResponse;

  ConfirmDialog({required this.onUserResponse});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('We need your Image!!'),
      content: const Text(
          'To make our model become more accurate we need more image can we store your image for training purpose?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => onUserResponse(true),
          child: Text('Yes'),
        ),
        TextButton(
          onPressed: () => onUserResponse(false),
          child: Text('No'),
        ),
      ],
    );
  }
}
