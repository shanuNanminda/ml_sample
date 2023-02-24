import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:live_ml/live_detection.dart';
import 'package:live_ml/snapshot_detection.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async{
                 List<CameraDescription>  cameras = await availableCameras();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LiveDetection(cameras: cameras),
                    ),
                  );
                },
                child: Text('live')),
            ElevatedButton(onPressed: () {
              Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SnapshotDetection(),
                    ),
                  );
            }, child: Text('snapshot')),
          ],
        ),
      ),
    );
  }
}
