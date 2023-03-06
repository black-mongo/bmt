import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'model/email.dart';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';

const url = 'https://xx.com';

enum OnlineStatus { init, logined, checkPassword }

class Controller extends GetxController {
  Controller(this.dio, this.isar);
  var counter = 0.obs;
  var lang = 'zh'.obs;
  var user = User().obs;
  var onlineStatus = OnlineStatus.init.obs;
  final Dio dio;
  // ignore: prefer_typing_uninitialized_variables
  final Isar isar;
  var settingRoute = "/login";
  var settingText = "btn_login".tr.obs;
  increment() => counter++;

  void setDioAdapter(HttpClientAdapter dioAdapter) {
    dio.httpClientAdapter = dioAdapter;
  }

  Future<void> reset() async {
    // 删除数据
    await isar.writeTxn(() async {
      await isar.users.delete(1);
    });
    settingRoute = "/login";
    settingText.value = "btn_login".tr;
    user.value.token = null;
    user.value.name = null;
    user.value.password = null;
  }

  @override
  void onInit() async {
    await getUser();
    if (user.value.token != null && user.value.password != null) {
      onlineStatus.value = OnlineStatus.checkPassword;
      settingRoute = "/setting";
      settingText.value = "btn_setting".tr;
    } else if (user.value.token != null) {
      settingRoute = "/setting/code";
      settingText.value = "btn_setting_code".tr;
    }
    super.onInit();
  }

  void chgLang() {
    if (lang.value == 'zh') {
      Get.updateLocale(const Locale('en', "US"));
      lang.value = "en";
    } else {
      Get.updateLocale(const Locale('zh', "CN"));
      lang.value = 'zh';
    }
  }

  void chgTheme() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.changeTheme(Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
  }

  Future<void> getUser() async {
    final existingUser = await isar.users.get(1); // get
    if (existingUser != null) {
      user.value = existingUser;
    }
    update();
  }

  ///
  /// 登陆
  ///
  Future<String> login(String user, String password) async {
    Set set = genSign(password);
    var resp = await post(getUrl('login'),
        {"username": user, "password": set.last, "timestamp": set.first});
    if (resp.data['code'] == 200) {
      final newUser = User()
        ..id = 1
        ..name = user
        ..token = resp.data['data']['token'];
      await isar.writeTxn(() async {
        await isar.users.put(newUser);
      });
      getUser();
      return "";
    } else {
      return resp.data["msg"];
    }
  }

  String getUrl(String name) {
    var urls = {
      "login": '/tokenapi/app/login',
      "code": "/tokenapi/2f",
      "list": "/get_secure_crt/user_bind_list"
    };
    return '$url${urls[name]}';
  }

  ///
  /// 获取绑定列表
  ///
  Future<List> getbindList() async {
    Set set = genSign(user.value.password!);
    var resp = await post(getUrl('list'), {
      "token": user.value.token,
      "password": set.last,
      "timestamp": set.first,
      "request_id": DateTime.now().microsecondsSinceEpoch.toString()
    });
    if (resp.data["code"] == 200) {
      return resp.data["data"]["data"];
    }
    return [];
  }

  ///
  /// 验证2次密码
  ///
  Future<String> checkSecondPassword(String password) async {
    Set set = genSign(password);
    var resp = await post(getUrl('code'), {
      "token": user.value.token,
      "password": set.last,
      "timestamp": set.first
    });
    if (resp.data["code"] == 200) {
      user.value.password = password;
      await isar.writeTxn(() async {
        await isar.users.put(user.value);
      });
      return "";
    } else {
      return resp.data["msg"];
    }
  }

  Set genSign(String password) {
    var now = DateTime.now().microsecondsSinceEpoch;
    var sha = sha1.convert(utf8.encode(password)).toString().toUpperCase() +
        now.toString();
    var sign = md5.convert(utf8.encode(sha)).toString().toUpperCase();
    return {now, sign};
  }

  Future<dynamic> post(String path, Object? data) async {
    try {
      var res = await dio.post(path, data: data);
      debugPrint('path = $path,data=$data,resp=$res');
      return res;
    } catch (e) {
      debugPrint("$e");
      return Future(() => null);
    }
  }
}
