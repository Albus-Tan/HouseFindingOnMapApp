//HouseList Widget
//main函数调用了实现了了无限长的List
import 'dart:math';

import 'package:flutter/material.dart';
import 'HouseCard.dart';
import 'HouseData.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'HouseList Demo';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const Center(
          child: HouseList(),
        ),
      ),
    );
  }
}

class HouseList extends StatefulWidget {
  const HouseList({Key? key}) : super(key: key);

  @override
  State<HouseList> createState() => _HouseListState();
}

class _HouseListState extends State<HouseList> {
  final _houseCards = <HouseCard>[];

  List<HouseCard> generateHouseCard(int num) {
    List<HouseCard> tmp = [];
    for (int i = 0; i < num; i++) {
      tmp.add(houseCardExample[Random().nextInt(houseCardExample.length)]);
    }
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // shrinkWrap:true,  //加了这个HouseList外面就不用了加Container或Expanded了
      padding: const EdgeInsets.all(16.0),
      itemBuilder: /*1*/ (context, i) {
        if (i.isOdd) return const Divider();
        /*2*/

        final index = i ~/ 2; /*3*/
        if (index >= _houseCards.length) {
          _houseCards.addAll(generateHouseCard(2)); /*4*/
        }
        return _houseCards[index];
      },
    );
  }
}
