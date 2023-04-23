import 'package:bmt/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otp/otp.dart';

void main() {
  test('uri parse', () async {
    final OtpAuth otp = Utils.parseOtpAuth(
        "otpauth://totp/BM:123@gmail.com?secret=1234&issuer=Example&algorithm=SHA1&digits=6&period=30");
    expect(otp.alg, Algorithm.SHA1);
    expect(otp.name, "BM:123@gmail.com");
    expect(otp.secret, "1234");
    expect(otp.issuer, "Example");
    expect(otp.digits, 6);
    expect(otp.period, 30);
  });
}
