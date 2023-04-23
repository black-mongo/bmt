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
    var now = seconds();
    var time = now - (now % 30);
    return OTP.generateTOTPCodeString(secret, time * 1000,
        algorithm: Algorithm.SHA1,
        interval: interval,
        length: digits,
        isGoogle: true);
  }

  static OtpAuth parseOtpAuth(String qrcode) {
    final u = Uri.parse(qrcode);
    final List<String> name = u.pathSegments;
    final secret = u.queryParameters["secret"];
    final digits = u.queryParameters["digtis"];
    final period = u.queryParameters["period"];
    final alg = u.queryParameters["algorithm"];
    final issuer = u.queryParameters["issuer"];

    return OtpAuth(
        secret: secret,
        name: name.isNotEmpty ? name[0] : null,
        issuer: issuer,
        digits: digits == null ? 6 : int.parse(digits),
        alg: alg == null ? Algorithm.SHA1 : parseAlg(alg),
        period: period == null ? 30 : int.parse(period));
  }

  static Algorithm parseAlg(String alg) {
    if (alg.toUpperCase() == "SHA256") {
      return Algorithm.SHA256;
    } else if (alg.toUpperCase() == "SHA512") {
      return Algorithm.SHA512;
    } else {
      return Algorithm.SHA1;
    }
  }
}

class OtpAuth {
  OtpAuth(
      {this.secret,
      this.name,
      this.digits = 6,
      this.alg = Algorithm.SHA1,
      this.period = 30,
      this.issuer});
  final String? secret;
  final int digits;
  final Algorithm alg;
  final int period;
  final String? name;
  final String? issuer;
}

class Type {
  String otp = "otp";
}
