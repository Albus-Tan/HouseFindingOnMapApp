

import 'package:app/house_card.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'HouseCard Demo';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const HouseCard(
          title: "城东刚需好房 东城名苑 精装 房东诚心出售",
          rooms: 3,
          squares: 89,
          community: "荣安美安府",
          price: 2000,
          url:
          "https://pic1.ajkimg.com/display/58ajk/bb2ea992a99e20c0eadf28414065f95d/640x420c.jpg?t=1",
        ),
      ),
    );
  }
}