import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:live_ml/live_detection.dart';
import 'package:live_ml/snapshot_detection.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  loadModel(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('select model'),
              content: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        
                        Navigator.pop(context);
                        await Tflite.loadModel(
                          model: 'assets/unquant_model/model.tflite',
                          labels: 'assets/unquant_model/labels.txt',
                        );
                      },
                      child: Text('unquant')),
                       ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await Tflite.loadModel(
                          model: 'assets/quant_models/model.tflite',
                          labels: 'assets/quant_models/labels.txt',
                        );
                      },
                      child: Text('quant'))
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  await loadModel(context);
                  List<CameraDescription> cameras = await availableCameras();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LiveDetection(cameras: cameras),
                    ),
                  );
                },
                child: Text('live')),
            ElevatedButton(
                onPressed: () async{
                  await loadModel(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SnapshotDetection(),
                    ),
                  );
                },
                child: Text('snapshot')),
          ],
        ),
      ),
    );
  }
}
