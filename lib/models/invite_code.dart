import 'dart:convert';
import 'package:crypto/crypto.dart';

class InviteCode {
  final String word;
  final DateTime dateTime;

  InviteCode(this.word, this.dateTime);

  String get hash {
    final jsonString = json.encode({
      'word': word,
      'inviteTime': dateTime.toString(),
    });
    final bytes = utf8.encode(jsonString);
    final hashBytes = md5.convert(bytes).bytes;
    return base64Url.encode(hashBytes);
  }
}
