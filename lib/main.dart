import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radar_application/radar_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Radar Location Search',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RadarLocationSearchPage(),
    );
  }
}
