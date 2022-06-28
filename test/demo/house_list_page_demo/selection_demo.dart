
import 'package:app/widgets/selection.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = "range_select_example";

  @override
  Widget build(BuildContext context) {
    // print(const JsonDecoder().convert(configSelect).runtimeType);
    return MaterialApp(
        home: Scaffold(
            appBar: BrnAppBar(title: _title),
            body: Column(
              children: <Widget>[
                selectionView(),
                Container(
                  padding: const EdgeInsets.only(top: 400),
                  alignment: Alignment.center,
                  child: const Text("背景内容区域"),
                )
              ],
            )));
  }
}