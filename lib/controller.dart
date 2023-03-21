import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bmt/utils.dart';
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
  var tokens = {}.obs;
  var bindType = "".obs;
  var teamcid = "";
  var s = 0;
  var e = 0;
  var process = 0.0.obs;
  String gesturePass = "";
  var unlocked = false.obs;
  List bindList = [];
  increment() => counter++;

  void setDioAdapter(HttpClientAdapter dioAdapter) {
    dio.httpClientAdapter = dioAdapter;
  }

  Future<void> logout() async {
    await reset();
    update(['i']);
  }

  Future<void> reset() async {
    // 删除数据
    await isar.writeTxn(() async {
      if (!await isar.users.delete(1)) {
        debugPrint("delete row error");
        return;
      }
    });
    user.value.token = null;
    user.value.name = null;
    user.value.password = null;
    onlineStatus.value = OnlineStatus.init;
    bindList = [];
    _update();
  }

  Future<void> manualInit() async {
    if (user.value.token != null && user.value.password != null) {
      unlocked.value = false;
    } else {
      unlocked.value = true;
    }
    await _update();
  }

  @override
  void onInit() async {
    if (user.value.token != null && user.value.password != null) {
      unlocked.value = false;
    } else {
      unlocked.value = true;
    }
    _update();
    Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      _changeProcess();

      ///定时任务
    });
    super.onInit();
  }

  Future<void> _update() async {
    await getUser();
    if (user.value.token != null && user.value.password != null) {
      onlineStatus.value = OnlineStatus.checkPassword;
      if (unlocked.value) await getbindList();
    } else if (user.value.token != null) {}
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
    return doLogin(user, password, Utils.epoch());
  }

  Future<String> doLogin(String user, String password, int now) async {
    Set set = genSign(password, now);
    var resp = await post(getUrl('login'),
        {"username": user, "password": set.last, "timestamp": set.first});
    if (resp != null && resp.data['code'] == 200) {
      final newUser = User()
        ..id = 1
        ..name = user
        ..token = resp.data['data']['token'];
      await isar.writeTxn(() async {
        await isar.users.put(newUser);
      });
      _update();
      return "";
    } else if (resp != null) {
      return resp.data["msg"];
    } else {
      return "连接网络失败";
    }
  }

  void select(String bindType, String teamcId) async {
    var data = {
      "request_id": Utils.epoch().toString(),
      "timestamp": Utils.epoch().toString(),
      "data": {
        "teamc_id": teamcId,
        "bind_type": bindType,
        "pw_length": "6",
        "period": "30"
      },
      "request_id": Utils.epoch().toString(),
      "signature": "xxx"
    };
    tokens.remove(bindType);
    process.value = 0;
    var resp = await doPost(getUrl('token'), data,
        options: Options(headers: {'x-token': _token()}));
    if (resp != null && resp.data["code"] == 200) {
      this.bindType.value = bindType;
      teamcid = teamcId;
      tokens.addEntries({bindType: resp.data["data"]["data"]["token"]}.entries);
      s = resp.data["data"]["data"]["start_time"];
      e = resp.data["data"]["data"]["end_time"];
      var total = e - s;
      var expired = Utils.seconds() - s;
      if (total > 0) process.value = expired / total;
      update(['token']);
    }
  }

  void _changeProcess() {
    var total = e - s;
    var expired = Utils.seconds() - s;
    if (total > 0) process.value = expired / total;
    if (process.value > 1) {
      select(bindType.value, teamcid);
    }
  }

  String _token() {
    return user.value.token ?? "";
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
    Set set = genSign(user.value.password!, Utils.epoch());
    debugPrint("pasword = ${user.value.password}");
    var resp = await post(getUrl('list'), {
      "token": user.value.token,
      "password": set.last,
      "timestamp": set.first.toString(),
      "data": "",
      "request_id": Utils.epoch().toString()
    });
    if (resp != null && resp.data["code"] == 200) {
      bindList = resp.data["data"]["data"];
      update(['listview']);
      return resp.data["data"]["data"];
    } else if (resp != null && resp.data["code"] == 120) {
      reset();
    }
    return [];
  }

  ///
  /// 验证2次密码
  ///
  Future<String> checkSecondPassword(String password) async {
    Set set = genSign(password, Utils.epoch());
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

  void set_unlock(bool flag) {
    unlocked.value = flag;
    update(['i']);
  }

  bool unlock(String password) {
    gesturePass = password;
    if ("1234" == password) {
      unlocked.value = true;
      update(['i']);
      return true;
    }
    return false;
  }

  Set genSign(String password, int now) {
    var sha = sha1.convert(utf8.encode(password)).toString().toUpperCase() +
        now.toString();
    var sign = md5.convert(utf8.encode(sha)).toString().toUpperCase();
    return {now, sign};
  }

  Future<dynamic> post(String path, Object? data) async {
    return doPost(path, data);
  }

  Future<dynamic> doPost(
    String path,
    Object? data, {
    Options? options,
  }) async {
    try {
      var res = await dio.post(path, data: data, options: options);
      debugPrint(
          'path = $path,data=$data,options=${options?.headers}, resp=$res');
      return res;
    } catch (e) {
      debugPrint("post error = $e");
      return Future(() => null);
    }
  }
}
