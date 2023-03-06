import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bmt/controller.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    final Controller c = Get.find();
    return Scaffold(
      appBar: AppBar(title: Text('text_title'.tr)),
      body: Column(children: [
        Center(
            child: ElevatedButton(
                child: Obx(() => Text(
                    "user:${c.user.value.name}, ${c.user.value.id},${c.user.value.token}")),
                onPressed: () => Get.offNamed("/other"))),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(c.settingRoute),
        child: Obx(() => Text(c.settingText.value)),
      ),
    );
  }
}

// ignore: use_key_in_widget_constructors
class Setting extends StatelessWidget {
  final Controller c = Get.find();
  final String? type = Get.parameters["type"];
  @override
  Widget build(BuildContext context) {
    if (type == "check_password") {
      return Scaffold(
          appBar: AppBar(title: Text("title".tr)),
          body: Center(
            child: TextField(
              decoration: InputDecoration(
                  labelText: "text_code".tr,
                  hintText: "hint_text_code".tr,
                  prefixIcon: Icon(Icons.lock)),
              obscureText: true,
            ),
          ));
    } else {
      return Scaffold(
        appBar: AppBar(title: Text("hello".tr)),
        body: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("${c.counter}"),
                TextButton(
                    onPressed: () => {c.chgTheme()},
                    child: Text("btn_change_theme".tr)),
                TextButton(
                    onPressed: () => {c.chgLang()},
                    child: Text("btn_change_lang".tr))
              ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed("/home"),
          child: const Icon(Icons.add),
        ),
      );
    }
  }
}
