import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

const users = const {
  'admin@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginPage extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    // return Future.delayed(loginTime).then((_) {
    //   return null;
    // });
    final Controller c = Get.find();
    return c.login(data.name, data.password);
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    // return Future.delayed(loginTime).then((_) {
    //   return null;
    // });
    final Controller c = Get.find();
    return c.login(data.name!, data.password!);
  }

  Future<String> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
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
    return FlutterLogin(
      title: 'titel'.tr,
      logo: const AssetImage('assets/images/logo.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () => Get.offNamed("/"),
      onRecoverPassword: _recoverPassword,
      userType: LoginUserType.name,
      userValidator: _userValidator,
    );
  }
}
