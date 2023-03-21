import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';
import 'package:flutter_login/flutter_login.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);
  final Controller c = Get.find();
  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    // return Future.delayed(loginTime).then((_) {
    //   return null;
    // });
    return c.login(data.name, data.password);
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    // return Future.delayed(loginTime).then((_) {
    //   return null;
    // });
    return c.login(data.name!, data.password!);
  }

  Future<String> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      return "";
    });
  }

  String? _userValidator(String? name) {
    if (name == null) {
      return "User is null";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (c.onlineStatus.value != OnlineStatus.init) {
      return Center(
        child: ElevatedButton(
          child: Text("btn_logout".tr),
          onPressed: () async {
            await c.logout();
            Get.offNamed("/");
          },
        ),
      );
    }
    return FlutterLogin(
      title: 'text_titel'.tr,
      // logo: const AssetImage('assets/images/logo.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () => Get.offNamed("/"),
      onRecoverPassword: _recoverPassword,
      userType: LoginUserType.name,
      userValidator: _userValidator,
    );
  }
}
