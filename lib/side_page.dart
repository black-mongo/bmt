import 'package:bmt/about_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class SidePage extends StatelessWidget {
  final Controller c = Get.find();

  @override
  Widget build(BuildContext context) {
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
            const Divider(),
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.people),
              ),
              onTap: () => Get.toNamed("/login"),
              onLongPress: () => Get.toNamed("/code"),
            ),
            const Divider(),
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.settings)),
              onTap: () => Get.toNamed("/setting"),
            ),
            const Divider(),
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.info)),
              onTap: () => Get.toNamed("/about"),
            ),
          ],
        ));
  }
}
