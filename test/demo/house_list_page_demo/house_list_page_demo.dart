import 'package:app/house_list_page.dart';
import 'package:flutter/material.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'HouseListPage Demo';

  @override
  Widget build(BuildContext context) {

    return const MaterialApp(
      title: _title,
      home: HouseListPage()
    );
  }
}