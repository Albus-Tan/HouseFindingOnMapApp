
// this entity correspond the backend result of user
import 'package:flutter/cupertino.dart';

class Result<T> {
  late int code;
  late String msg;
  T? detail;

  Result({required this.code, required this.msg, this.detail});

  Result.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    detail = json['detail'];
  }

}
