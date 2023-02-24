import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';

class SnapshotDetection extends StatefulWidget {
  const SnapshotDetection({super.key});

  @override
  State<SnapshotDetection> createState() => _SnapshotDetectionState();
}

var result;

class _SnapshotDetectionState extends State<SnapshotDetection> {
  pickImage() async {
    XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    runOnModel(File(pickedImage!.path));
  }

  runOnModel(File image) async {
    result = await Tflite.runModelOnImage(
      path: image.path,
      
      threshold: 0.1,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 2,
    );
    print(result);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Tflite.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('$result'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        pickImage();
      }),
    );
  }
}
