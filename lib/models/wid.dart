import 'package:jozapp_flutter/models/types.dart';

// const _code = [4, 11, 9, 2, 14, 5, 0, 13, 10, 6, 1, 8, 12, 3, 7];
const _primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199];


String _formalCustomerNumber(String? number) {
  return (number ?? "").split("-").join("");
}

int _sumDigits(int n) {
  int sum = 0;
  while (n > 0) {
    sum += n % 10;
    n = (n / 10).floor();
  }
  return sum;
}

int _sumDigits0(int n) {
  int p = n;
  while (p >= 10) {
    p = _sumDigits(p);
  }
  return p;
}

int _checkSum(c) {
  int sum = 7;
  for(int i=0; i<15; i++) {
    int a = c[i];
    sum += _primes[i]*a;
  }
  return _sumDigits0(sum);
}

bool _validCustomerNumber(String? number) {
  String p = _formalCustomerNumber(number);
  if(p.length != 16) return false;
  List<int> c = [];
  for(var i=0; i<16; i++) {
    int? a = int.tryParse(p[i]);
    if(a == null) return false;
    c.add(a);
  }
  return c[15] == _checkSum(c);
}
//
// void testIt() {
//   log(_sumDigits(2537).toString());
//   log(_sumDigits0(2537).toString());
//   log(_validCustomerNumber("0002-5377-5311-6001").toString());
// }


const String _empty = "0000000000000000";

class Wid {

  factory Wid.empty() {
    return Wid._(_empty);
  }

  static Wid? fromFormal(String formal) {
    if(formal.length != 19) {
      return null;
    } else {
      var std = formal.split("-").join("");
      return _validCustomerNumber(std) ? Wid._(std) : null;
    }

  }

  factory Wid.fromJson(Json json, [String key = "wid"]) {
    return Wid._(getStringField(json, key, defValue: _empty));
  }

  final String value;

  Wid._(this.value);

  String get toQrCode => "iw-$value-wi";

  //iw-0002537753116001-wi
  static Wid? fromBarCode(String? data) {
    String p = data ?? "";
    if(p.length != 22) return null;
    var tt = p.split("-");
    if(tt.length != 3) return null;
    if(tt[0] != "iw") return null;
    if(tt[2] != "wi") return null;
    if(!_validCustomerNumber(tt[1])) return null;
    return Wid._(tt[1]);
  }

  String get formal => [
    value.substring(0, 4),
    value.substring(4, 8),
    value.substring(8, 12),
    value.substring(12),
  ].join("-");

  @override
  String toString() => value;



}