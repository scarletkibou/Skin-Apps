import 'package:camera/camera.dart';
import 'package:firebase_r/preview_page.dart';
import 'package:firebase_r/widgets/dialog.dart';
import 'package:firebase_r/widgets/instruction.dart';
import 'package:firebase_r/widgets/top_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TempCamera extends StatefulWidget {
  const TempCamera({Key? key, required this.cameras}) : super(key: key);

  final List<CameraDescription>? cameras;

  @override
  State<TempCamera> createState() => _TempCameraState();
}

class _TempCameraState extends State<TempCamera> {
  late CameraController _cameraController;
  bool _isRearCameraSelected = true;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeController();
    _openImageDialog();
  }

  Future<void> _initializeController() async {
    final cameraDescription = widget.cameras![0];
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);
    await _cameraController.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return;
    }
    if (_cameraController.value.isTakingPicture) {
      return;
    }
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      final XFile picture = await _cameraController.takePicture();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewPage(
            picture: picture,
          ),
        ),
      );
    } on CameraException catch (e) {
      debugPrint('Error occurred while taking a picture: $e');
    }
  }

  void _toggleCamera() {
    setState(() {
      _isRearCameraSelected = !_isRearCameraSelected;
      _initializeController();
    });
  }

  void _openImageDialog() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showDialog(context: context, builder: (_) => ImageDialog());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          if (_cameraController.value.isInitialized)
            CameraPreview(_cameraController)
          else
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: const Color(0xFF398378),
            ),
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                takePicture();
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 50, vertical: 150),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.red,
                    width: 6.0,
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            top: 40,
            right: 20,
            child: Instruction(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.20,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 50,
                      icon: Icon(
                        _isRearCameraSelected
                            ? CupertinoIcons.switch_camera
                            : CupertinoIcons.switch_camera_solid,
                        color: Colors.red,
                      ),
                      onPressed: _toggleCamera,
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      onPressed: takePicture,
                      iconSize: 80,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      icon: const Icon(
                        Icons.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
