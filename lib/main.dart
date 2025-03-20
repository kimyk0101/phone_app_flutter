import 'package:flutter/material.dart';
import 'package:phone_app_flutter/list.dart';
import 'package:phone_app_flutter/writeForm.dart';
import 'package:phone_app_flutter/editForm.dart';
import 'package:phone_app_flutter/detailPage.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //  디버그 표시 삭제
      debugShowCheckedModeBanner: false,
      title: 'phone_app_flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const SplashScreen(),

      routes: {
        "/home": (context) => const PhoneAppList(),
        "/insert": (content) => const WriteForm(),
        "/update": (context) => const EditForm(),
        "/detail": (context) => const DetailPage(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PhoneAppList()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Lottie.asset('assets/loading_animation.json')),
    );
  }
}
