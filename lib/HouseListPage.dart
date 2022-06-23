import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'HouseList.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'HouseListPage Demo';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const Center(
          child: HouseListPage(),
        ),
      ),
    );
  }
}

class HouseListPage extends StatefulWidget {
  const HouseListPage({Key? key}) : super(key: key);

  @override
  State<HouseListPage> createState() => _HouseListPageState();
}

class _HouseListPageState extends State<HouseListPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [


        HouseList(),
      ],
    );
  }
}
