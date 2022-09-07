//筛选器封装文件，内部有只含selection的main程序 不过存在高度溢出问题
import 'dart:convert';

import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef MyFunction = void Function(int, Map<String, String>, Map<String, String>, void Function({bool isMenuTitleHighLight, String menuTitle}));

Future<Widget> selectionView(String path, MyFunction callback) async {
  final json = await rootBundle.loadString(path);

  return BrnSelectionView(
    originalSelectionData: BrnSelectionEntityListBean.fromJson(
      const JsonDecoder().convert(json)['data'],
    )!
        .list!,
    onSelectionChanged: callback,
  );
}
