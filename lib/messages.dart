import 'package:get/get.dart';

class Messages extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
        "zh_CN": {
          "text_title": "黑芒令牌",
          "text_copyright": "Black-Mongo © 2023",
          "text_scan_tip": "扫描二维码",
          "btn_change_theme": "修改主题",
          "btn_change_lang": "修改语言",
          "btn_login": "登陆",
          "btn_logout": "退出登陆",
          "btn_setting": "设置",
          "btn_setting_code": "设置验证码",
          "text_login": "登陆页面",
          "text_code": "验证码",
          "hint_text_code": "你的验证码",
          "btn_code_click": "确定",
          "text_about": "黑芒令牌出品，侵权必究"
        },
        'en': {
          "text_title": "BmToken",
          "text_scan_tip": "Scan Qrcode",
          "text_copyright": "Black-Mongo © 2023",
          "btn_change_theme": "Change Theme",
          "btn_change_lang": "Change language",
          "btn_login": "Login",
          "btn_logout": "Logout",
          "btn_setting": "Setting",
          "btn_setting_code": "Setting code",
          "text_login": "Login Page",
          "text_code": "Verify code",
          "hint_text_code": "Your Verify code",
          "btn_code_click": "OK",
          "text_about":
              "Black Mongo token production\ninfringement must be investigated"
        }
      };
}
