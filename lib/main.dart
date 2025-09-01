import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: ImageFromAssetScreen(),
    );
  }
}

class ImageFromAssetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text('Display Image From Asset')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Zedric Matulin Rulloda'),
            Text('BSIT-II'),
            Text('December 8, 2002'),
            Text('Sagittarius'),
            Image.asset('assets/images/flutter.png',
                width:100,
                height: 100),
            Image.asset('assets/images/bossing.jpg',
                width:100,
                height: 100),
            Image.asset('assets/images/burspeyd.jpg',
                width:100,
                height: 100),
            Image.asset('assets/images/wow.jpg',
                width:100,
                height: 100),
            Image.asset('assets/images/galing.jpg',
                width:100,
                height: 100),
          ]
        ),
      ),
    );
  }
}

