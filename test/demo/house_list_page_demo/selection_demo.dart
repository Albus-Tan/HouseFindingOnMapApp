import 'package:app/widgets/selection.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  static const String _title = "range_select_example";
  late final Widget selection;
  bool selectionInitialized = false;

  @override
  Widget build(BuildContext context) {
    // print(const JsonDecoder().convert(configSelect).runtimeType);
    selectionView('assets/json/selection.json').then(
          (value) =>
          setState(
                () {
              selection = value;
              selectionInitialized = true;
            },
          ),
    );
    final list = <Widget>[];
    if (selectionInitialized) {
      list.add(selection);
    }
    list.add(
        Container(
          padding: const EdgeInsets.only(top: 400),
          alignment: Alignment.center,
          child: const Text("背景内容区域"),
        )
    );
    return MaterialApp(
      home: Scaffold(
        appBar: BrnAppBar(title: _title),
        body: Column(
          children: list,
        ),
      ),
    );
  }
}