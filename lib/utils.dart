import 'package:otp/otp.dart';

class Utils {
  static int seconds() {
    int e = epoch();
    return e - e % 1000;
  }

  static int epoch() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static String calcOtp(String secret, {int interval = 30, int digits = 6}) {
    return OTP.generateTOTPCodeString(secret, epoch(),
        interval: interval, length: digits);
  }
}
