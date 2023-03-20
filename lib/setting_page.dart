// ignore: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class SettingPage extends StatelessWidget {
  final Controller c = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("text_title".tr)),
        body: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                    onPressed: () => {c.chgTheme()},
                    child: Text(
                      "btn_change_theme".tr,
                      style: const TextStyle(fontSize: 20),
                    )),
                ElevatedButton(
                    onPressed: () => {c.chgLang()},
                    child: Text(
                      "btn_change_lang".tr,
                      style: const TextStyle(fontSize: 20),
                    ))
              ]),
        ));
  }
}
