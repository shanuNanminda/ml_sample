
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

import 'homepage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   Tflite.close();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}
