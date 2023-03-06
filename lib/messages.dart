import 'package:get/get.dart';

class Messages extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
        "zh_CN": {
          "title": "黑芒令牌",
          "btn_change_theme": "修改主题",
          "btn_change_lang": "修改语言",
          "btn_login": "登陆",
          "btn_setting": "设置",
          "btn_setting_code": "设置验证码",
          "text_login": "登陆页面",
          "text_code": "验证码",
          "hint_text_code": "你的验证码"
        },
        'en': {
          "title": "BmToken",
          "btn_change_theme": "Change Theme",
          "btn_change_lang": "Change language",
          "btn_login": "Login",
          "btn_setting": "Setting",
          "btn_setting_code": "Setting code",
          "text_login": "Login Page",
          "text_code": "Verify code",
          "hint_text_code": "Your Verify code"
        }
      };
}
