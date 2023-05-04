import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'controller.dart';

class CodePage extends StatelessWidget {
  final Controller c = Get.find();
  final String? type = Get.parameters["type"];
  String password = "";

  CodePage({super.key});
  void checkCode() async {
    debugPrint("set password = $password");
    if (await c.checkSecondPassword(password) == "") {
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
              onChanged: (value) => password = value,
            ),
            TextButton(
                onPressed: () => checkCode(), child: Text("btn_code_click".tr))
          ]),
        ));
  }
}
