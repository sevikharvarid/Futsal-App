import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  // late Future<void> _initializeCameraControllerFuture;
  late var _initializeCameraControllerFuture;
  bool isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Future<void> _initializeCamera() async {
  _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    _initializeCameraControllerFuture = _cameraController.initialize();
    setState(() {});
  }

  String imageToBase64(String imagePath) {
    File imageFile = File(imagePath);
    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Ambil Foto'),
      ),
      body: FutureBuilder<void>(
        future: _initializeCameraControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              _cameraController.value.isInitialized) {
            return CameraPreview(_cameraController);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: const Icon(Icons.camera, color: Colors.black),
        onPressed: () {
          _takePicture(context);
        },
      ),
    );
  }

  void _takePicture(BuildContext context) async {
    try {
      final XFile picture = await _cameraController.takePicture();

      String imagePath = picture.path;
      String base64Image = imageToBase64(imagePath);
      Navigator.pop(context, base64Image);
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  void _toggleFlash() async {
    try {
      if (_cameraController.value.isInitialized) {
        final flashMode = isFlashOn ? FlashMode.always : FlashMode.off;
        print("toggleFlash $flashMode");
        await _cameraController.setFlashMode(flashMode);
      }
    } catch (e) {
      print('Error toggling flash: $e');
    }
  }
}
