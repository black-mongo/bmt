// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:math';

import 'package:bmt/controller.dart';
import 'package:bmt/model/email.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bmt/main.dart';
import 'package:get/get.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:isar/isar.dart';

void main() {
  test('a', () async {
    final dio = Dio();
    final dioAdapter = DioAdapter(dio: dio);

    const path = 'https://example.com';

    dioAdapter.onGet(
      path,
      (server) => server.reply(
        200,
        {'message': 'Success!'},
        // Reply would wait for one-sec before returning data.
        delay: const Duration(seconds: 1),
      ),
    );
    final response = await dio.get(path);
    print(response.data); // {message: Success!}
  });
  test('test controller', () async {
    await Isar.initializeIsarCore(download: false);
    var db = await Isar.open([UserSchema]);
    Controller c = Controller(Dio(), db);
    await c.reset();
    final dioAdapter = DioAdapter(dio: c.dio);
    var loginUrl = c.getUrl('login');
    var now = DateTime.now().microsecondsSinceEpoch;
    var sign = c.genSign('123456', now);
    var data = <String, dynamic>{
      "username": 'tomtang300',
      'password': sign.last,
      "timestamp": now.toString()
    };
    dioAdapter.onPost(
        loginUrl,
        (server) => server.reply(
              200,
              {
                'data': {'token': 'token_test'},
                'code': 200
              },
              // Reply would wait for one-sec before returning data.
              delay: const Duration(microseconds: 1),
            ),
        data: data);
    expect(await c.doLogin('tomtang300', '123456', now), '');
  });
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // await Isar.initializeIsarCore(download: false);
    // Build our app and trigger a frame.
    // var db = Isar.openSync([UserSchema]);
    // Controller c = Controller(Dio(), db);
    // await c.reset();
    // expect(res, "");
    // expect(c.checkSecondPassword('1234'), "");
    // await tester.pumpWidget(app(db));
    // final Controller c = Get.find();
    // await c.reset();
    // var res = await c.login('tomtang300', '123456');
    // expect(c.onlineStatus.value, OnlineStatus.init);
    // expect(c.settingText.value, "btn_login".tr);
    // // Verify that our counter starts at 0.
    // expect(find.text('btn_login'.tr), findsOneWidget);
    // await tester.tap(find.byType(FloatingActionButton));
    // await tester.pump();

    // // Verify that our counter has incremented.
    // expect(find.byType(TextField), findsOneWidget);
    // expect(find.text('1'), findsOneWidget);
  });
}
