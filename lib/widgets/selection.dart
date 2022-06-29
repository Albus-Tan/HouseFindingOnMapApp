//筛选器封装文件，内部有只含selction的main程序 不过存在高度溢出问题
import 'dart:convert';

import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<Widget> selectionView(String path) async {
  final json = await rootBundle.loadString(path);

  return BrnSelectionView(
    originalSelectionData: BrnSelectionEntityListBean.fromJson(
      const JsonDecoder().convert(json)['data'],
    )!
        .list!,
    onSelectionChanged: (
      int menuIndex,
      Map<String, String> filterParams,
      Map<String, String> customParams,
      BrnSetCustomSelectionMenuTitle setCustomTitleFunction,
    ) {
      debugPrint("Select: $filterParams");
    },
    onSelectionPreShow: (int index, BrnSelectionEntity entity) {
      if (entity.key == "one_range_key" || entity.key == "two_range_key") {
        return BrnSelectionWindowType.range;
      }
      return entity.filterShowType!;
    },
  );
}
