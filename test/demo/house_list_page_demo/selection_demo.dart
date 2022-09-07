import 'package:app/widgets/selection.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

void callback(
    int menuIndex,
    Map<String, String> filterParams,
    Map<String, String> customParams,
    BrnSetCustomSelectionMenuTitle setCustomTitleFunction) {}

class _MyAppState extends State<MyApp> {
  static const String _title = "range_select_example";
  late final Widget selection;
  bool selectionInitialized = false;

  @override
  Widget build(BuildContext context) {
    // print(const JsonDecoder().convert(configSelect).runtimeType);
    selectionView(
      'assets/json/selection.json',
      callback,
    ).then(
      (value) => setState(
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
