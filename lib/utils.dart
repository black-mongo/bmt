import 'package:otp/otp.dart';

class Utils {
  static final type = Type();
  static int seconds() {
    int e = epoch();
    return e ~/ 1000;
  }

  static int epoch() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static String calcOtp(String secret, {int interval = 30, int digits = 6}) {
    return OTP.generateTOTPCodeString(secret, epoch(),
        interval: interval, length: digits);
  }
}

class Type {
  String otp = "otp";
}
