import 'dart:io';

import 'package:firebase_r/CameraPage.dart';
import 'package:firebase_r/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_r/widgets/top_camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'main.dart';

class TempCamera extends StatefulWidget {
  const TempCamera({Key? key}) : super(key: key);

  @override
  State<TempCamera> createState() => _TempCameraState();
}

class _TempCameraState extends State<TempCamera> {
  var uuid = const Uuid();
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  XFile? image;

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> saveImage(XFile image) async {
    var name = uuid.v4();
    final Directory? downloadsDir = await getDownloadsDirectory();
    final imagePath = '${downloadsDir?.path}/$name';
    final File savedImage = File(imagePath);
    await savedImage.writeAsBytes(await image.readAsBytes());

    print('Image saved at: $imagePath');
  }

  Future<XFile?> takePicture() async {
    final CameraController cameraController = _cameraController;
    if (!cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      return null;
    }

    try {
      final XFile file = await cameraController.takePicture();
      return file;
    } on CameraException {
      return null;
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((XFile? file) {
      if (mounted) {
        setState(() {
          image = file;
          _cameraController.dispose();
        });
        if (file != null) {
          showInSnackBar('Picture saved to ${file.path}');
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    final camera = getCameras().first;
    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(context: context, builder: (_) => ImageDialog());
            });
            return Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: CameraPreview(_cameraController),
                ),
                Positioned.fill(
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.red,
                        width: 6.0,
                      ),
                    ),
                  ),
                ),
                const TopBar(),
                Positioned(
                  bottom: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        if (_cameraController.value.isInitialized) {
                          image = await _cameraController.takePicture();
                          if (image != null) {
                            await saveImage(image!); // Save the captured image
                          }
                        }
                      } catch (e) {
                        print(e); // Show error
                      }
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.catching_pokemon_sharp,
                          color: Colors.red,
                          size: 120,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
