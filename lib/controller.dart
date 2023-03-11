import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'model/email.dart';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';

const url = "https://xxx.net";

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
  var tokens = {}.obs;
  var bindType = "".obs;
  var teamcid = "";
  var s = 0;
  var e = 0;
  var process = 0.0.obs;
  List gesturePassPath = [];
  var unlocked = true.obs;
  List bindList = [];
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
    _update();
  }

  Future<void> manualInit() async {
    await _update();
  }

  @override
  void onInit() async {
    _update();
    Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      debugPrint("timer");
      _changeProcess();

      ///定时任务
    });
    super.onInit();
  }

  Future<void> _update() async {
    await getUser();
    if (user.value.token != null && user.value.password != null) {
      onlineStatus.value = OnlineStatus.checkPassword;
      settingRoute = "/setting";
      settingText.value = "btn_setting".tr;
      unlocked.value = false;
      if (unlocked.value) await getbindList();
    } else if (user.value.token != null) {
      settingRoute = "/setting/code";
      settingText.value = "btn_setting_code".tr;
    }
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
  ///
  Future<String> login(String user, String password) async {
    return doLogin(user, password, DateTime.now().millisecondsSinceEpoch);
  }

  Future<String> doLogin(String user, String password, int now) async {
    Set set = genSign(password, now);
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
      _update();
      return "";
    } else {
      return resp.data["msg"];
    }
  }

  void select(String bindType, String teamcId) async {
    var data = {
      "request_id": DateTime.now().millisecondsSinceEpoch.toString(),
      "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
      "data": {
        "teamc_id": teamcId,
        "bind_type": bindType,
        "pw_length": "6",
        "period": "30"
      },
      "request_id": DateTime.now().millisecondsSinceEpoch.toString(),
      "signature": "xxx"
    };
    var resp = await doPost(
        getUrl('token'), data, Options(headers: {'x-token': user.value.token}));
    if (resp != null && resp.data["code"] == 200) {
      this.bindType.value = bindType;
      teamcid = teamcId;
      tokens.addEntries({bindType: resp.data["data"]["data"]["token"]}.entries);
      s = resp.data["data"]["data"]["start_time"];
      e = resp.data["data"]["data"]["end_time"];
      var total = e - s;
      var expired = DateTime.now().millisecondsSinceEpoch / 1000 - s;
      if (total > 0) process.value = expired / total;
      update(['i']);
    }
  }

  void _changeProcess() {
    var total = e - s;
    var expired = DateTime.now().millisecondsSinceEpoch / 1000 - s;
    if (total > 0) process.value = expired / total;
    if (process.value > 1) {
      select(bindType.value, teamcid);
    }
  }

  String getUrl(String name) {
    var urls = {
      "login": '/tokenapi/app/login',
      "code": "/tokenapi/2f",
      "list": "/get_secure_crt/user_bind_list",
      "token": "/get_secure_crt/get_token"
    };
    return '$url${urls[name]}';
  }

  ///
  /// 获取绑定列表
  ///
  Future<List> getbindList() async {
    Set set =
        genSign(user.value.password!, DateTime.now().millisecondsSinceEpoch);
    debugPrint("pasword = ${user.value.password}");
    var resp = await post(getUrl('list'), {
      "token": user.value.token,
      "password": set.last,
      "timestamp": set.first.toString(),
      "data": "",
      "request_id": DateTime.now().microsecondsSinceEpoch.toString()
    });
    if (resp != null && resp.data["code"] == 200) {
      bindList = resp.data["data"]["data"];
      update(['listview']);
      return resp.data["data"]["data"];
    } else if (resp.data["code"] == 120) {
      reset();
    }
    return [];
  }

  ///
  /// 验证2次密码
  ///
  Future<String> checkSecondPassword(String password) async {
    Set set = genSign(password, DateTime.now().microsecondsSinceEpoch);
    var resp = await post(getUrl('code'), {
      "token": user.value.token,
      "password": set.last,
      "timestamp": set.first
    });
    if (resp != null && resp.data["code"] == 200) {
      user.value.password = password;
      await isar.writeTxn(() async {
        await isar.users.put(user.value);
      });
      _update();
      return "";
    } else if (resp != null && resp.data["code"] == 120) {
      reset();
      return resp.data["msg"];
    } else if (resp != null) {
      return resp.data["msg"];
    } else {
      return "请求返回错误";
    }
  }

  void unlock(List<int> passwordPath) async {
    gesturePassPath = passwordPath;
    if ("$passwordPath" == "[0, 1, 2, 3]") unlocked.value = true;
    update(['i']);
    return;
  }

  Set genSign(String password, int now) {
    var sha = sha1.convert(utf8.encode(password)).toString().toUpperCase() +
        now.toString();
    var sign = md5.convert(utf8.encode(sha)).toString().toUpperCase();
    return {now, sign};
  }

  Future<dynamic> post(String path, Object? data) async {
    return doPost(path, data, null);
  }

  Future<dynamic> doPost(
    String path,
    Object? data,
    Options? options,
  ) async {
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
