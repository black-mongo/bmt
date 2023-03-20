import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'controller.dart';

class CodePage extends StatelessWidget {
  final Controller c = Get.find();
  final String? type = Get.parameters["type"];

  CodePage({super.key});
  void checkCode() async {
    if (await c.checkSecondPassword("1234") == "") {
      Get.offNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("text_title".tr)),
        body: Center(
          child: Column(children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  labelText: "text_code".tr,
                  hintText: "hint_text_code".tr,
                  prefixIcon: Icon(Icons.lock)),
              obscureText: true,
            ),
            TextButton(
                onPressed: () => checkCode(), child: Text("btn_code_click".tr))
          ]),
        ));
  }
}
