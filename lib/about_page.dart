import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("text_title".tr)),
      body: Center(
          child: Text(
        "text_about".tr,
        style: const TextStyle(fontSize: 20),
      )),
    );
  }
}
