import 'package:bmt/gesture/gestures_unlock.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'controller.dart';

class UnlockPage extends StatelessWidget {
  UnlockPage({super.key});
  final Controller c = Get.find();
  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;
    return GetBuilder<Controller>(
        id: 'gesture',
        builder: (_) => Column(
              children: [GesturesUnlock()],
            ));
  }
}
