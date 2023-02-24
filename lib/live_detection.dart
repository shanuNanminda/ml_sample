
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

class LiveDetection extends StatefulWidget {
   LiveDetection({super.key,required this.cameras});
  List<CameraDescription> cameras;
  @override
  _LiveDetectionState createState() => _LiveDetectionState();
}

class _LiveDetectionState extends State<LiveDetection> {
  CameraController? cameraController;
  CameraImage? cameraImage;
  List? recognitionsList;

  initCamera() {
    cameraController = CameraController(widget.cameras[1], ResolutionPreset.low);
    cameraController!.initialize().then((value) {
      cameraController!.startImageStream((image) async {
        setState(() {
          cameraImage = image;
        });
        // await Future.delayed(Duration(milliseconds: 300));
        runModel(image);
      });
    });
  }

  runModel(CameraImage cameraImage) async {
    
    recognitionsList = await Tflite.runModelOnFrame(
      bytesList: cameraImage.planes.map((plane) {
        return plane.bytes;
      }).toList(),
      imageHeight: cameraImage.height,
      imageWidth: cameraImage.width,
      imageMean: 127.5,
      imageStd: 127.5,
      // numResultsPerClass: 1,
      threshold: 0.4,
    );
print(recognitionsList);
    // setState(() {
    //   cameraImage;
    // });
  }

  Future loadModel() async {
    
    // Tflite.close();
    // await Tflite.loadModel(
    //     model: "assets/model.tflite",
    //     labels: "assets/labels.txt");
  }

  @override
  void dispose() {
    super.dispose();

    cameraController!.stopImageStream();
    Tflite.close();
  }

  @override
  void initState() {
    super.initState();

    loadModel();
    initCamera();
  }
List<CameraDescription>? cameras;
  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (recognitionsList == null) return [];

    double factorX = screen.width;
    double factorY = screen.height;

    Color colorPick = Colors.pink;

    return recognitionsList!.map((result) {
      return Positioned(
        left: result["rect"]["x"] * factorX,
        top: result["rect"]["y"] * factorY,
        width: result["rect"]["w"] * factorX,
        height: result["rect"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            "${result['detectedClass']} ${(result['confidenceInClass'] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: Colors.black,
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> list = [];

    list.add(
      Positioned(
        top: 0.0,
        left: 0.0,
        width: size.width,
        height: size.height - 100,
        child: SizedBox(
          height: size.height - 100,
          child: (!cameraController!.value.isInitialized)
              ? const SizedBox()
              : AspectRatio(
                  aspectRatio: cameraController!.value.aspectRatio,
                  child: CameraPreview(cameraController!),
                ),
        ),
      ),
    );

    if (cameraImage != null) {
      list.addAll(displayBoxesAroundRecognizedObjects(size));
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          margin: const EdgeInsets.only(top: 50),
          color: Colors.black,
          child: Stack(
            children: list,
          ),
        ),
      ),
    );
  }
}
