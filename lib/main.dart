import 'package:bmt/gesture/gestures_unlock.dart';
import 'package:bmt/login_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:bmt/controller.dart';
import 'package:bmt/messages.dart';
import 'package:isar/isar.dart';
import 'dart:ui' as ui;
import 'home.dart';
import 'model/email.dart';

void main() async {
  var db = await Isar.open([UserSchema]);
  Controller c = Controller(Dio(), db);
  await c.manualInit();
  runApp(app(c));
}

GetMaterialApp app(Controller c) {
  return GetMaterialApp(
    initialRoute: "/",
    translations: Messages(),
    // locale: Locale('zh', 'CN'),
    locale: ui.window.locale,
    fallbackLocale: Locale('en', "US"),
    getPages: [
      GetPage(
          name: "/",
          page: () => Home(),
          binding:
              BindingsBuilder(() => Get.put<Controller>(c, permanent: true))),
      GetPage(
        name: "/login",
        page: () => LoginPage(),
      ),
      GetPage(name: "/setting/:type", page: () => Setting())
    ],
  );
}
