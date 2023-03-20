import 'package:bmt/gesture/gestures_unlock.dart';
import 'package:bmt/scanner_page.dart';
import 'package:bmt/token_page.dart';
import 'package:bmt/unlock_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bmt/controller.dart';

import 'loading.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  final Controller c = Get.find();
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); //添加观察者
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final Controller c = Get.find();
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    switch (state) {
      //进入应用时候不会触发该状态 应用程序处于可见状态，并且可以响应用户的输入事件。它相当于 Android 中Activity的onResume
      case AppLifecycleState.resumed:
        print("应用进入前台======");
        c.set_unlock(false);
        break;
      //应用状态处于闲置状态，并且没有用户的输入事件，
      // 注意：这个状态切换到 前后台 会触发，所以流程应该是先冻结窗口，然后停止UI
      case AppLifecycleState.inactive:
        print("应用处于闲置状态，这种状态的应用应该假设他们可能在任何时候暂停 切换到后台会触发======");
        break;
      //当前页面即将退出
      case AppLifecycleState.detached:
        print("当前页面即将退出======");
        break;
      // 应用程序处于不可见状态
      case AppLifecycleState.paused:
        print("应用处于不可见状态 后台======");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: ElevatedButton(
          child: const Icon(Icons.menu),
          onPressed: () {
            _globalKey.currentState?.openDrawer();
          },
        ),
        title: Text('text_title'.tr),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'text_scan_tip'.tr,
            onPressed: () {
              Get.toNamed("/scanner");
            },
          ),
        ],
      ),
      drawer: draw(),
      body: SafeArea(
          child: GetBuilder<Controller>(id: 'i', builder: (_) => bindList())),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(c.settingRoute),
        child: Obx(() => Text(c.settingText.value)),
      ),
    );
  }

  Widget bindList() {
    final Controller c = Get.find();
    if (c.unlocked.value == true) {
      return const TokenPage();
    } else {
      return UnlockPage();
    }
  }
}

// ignore: use_key_in_widget_constructors
class Setting extends StatelessWidget {
  final Controller c = Get.find();
  final String? type = Get.parameters["type"];
  void checkCode() async {
    if (await c.checkSecondPassword("1234") == "") {
      Get.offNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (type == "code") {
      return Scaffold(
          appBar: AppBar(title: Text("title".tr)),
          body: Center(
            child: Column(children: <Widget>[
              TextField(
                decoration: InputDecoration(
                    labelText: "text_code".tr,
                    hintText: "hint_text_code".tr,
                    prefixIcon: Icon(Icons.lock)),
                obscureText: true,
              ),
              TextButton(onPressed: () => checkCode(), child: Text("确定"))
            ]),
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

Drawer draw() {
  return Drawer(
      width: 80,
      child: Column(
        children: <Widget>[
          // DrawerHeader(
          //   decoration: BoxDecoration(
          //       color: Colors.yellow,
          //       image: DecorationImage(
          //           image:
          //               NetworkImage("https://www.itying.com/images/flutter/2.png"),
          //           fit: BoxFit.cover)),
          //   child: ListView(
          //     children: <Widget>[Text('我是一个头部')],
          //   ),
          // ),
          Divider(),
          ListTile(
            // title: Text("个人中心"),
            leading: CircleAvatar(child: Icon(Icons.people)),
          ),
          Divider(),
          ListTile(
            // title: Text("系统设置"),
            leading: CircleAvatar(child: Icon(Icons.settings)),
          )
        ],
      ));
}
