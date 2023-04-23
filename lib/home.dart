import 'package:bmt/gesture/gestures_unlock.dart';
import 'package:bmt/scanner_page.dart';
import 'package:bmt/side_page.dart';
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
      drawer: SidePage(), // left side page
      body: SafeArea(
          child: GetBuilder<Controller>(id: 'i', builder: (_) => bindList())),
    );
  }

  Widget bindList() {
    final Controller c = Get.find();
    if (c.unlocked.value == true) {
      return const TokenPage();
    } else {
      // gesture to unlock page
      return UnlockPage();
    }
  }
}
