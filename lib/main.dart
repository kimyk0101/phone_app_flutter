import 'package:flutter/material.dart';
import 'package:phone_app_flutter/list.dart';
import 'package:phone_app_flutter/writeForm.dart';
import 'package:phone_app_flutter/editForm.dart';
// import 'package:phone_app_flutter/app_editForm.dart';
import 'package:phone_app_flutter/detailPage.dart';
// import 'package:phone_app_flutter/app_detailPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'phone_app_flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const PhoneAppList(),
        "/insert": (content) => const WriteForm(),
        "/update": (context) => const EditForm(),
        "/detail": (context) => const DetailPage(),
      },
    );
  }
}
