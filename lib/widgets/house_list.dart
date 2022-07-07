import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../service/backend_service/select_house.dart';
import 'house_card.dart';
import 'house_list/house_data.dart';

class HouseList extends StatefulWidget {
  final Map<String, String>? filter;

  const HouseList({this.filter, Key? key}) : super(key: key);

  @override
  State<HouseList> createState() => _HouseListState();
}

class _HouseListState extends State<HouseList> {
  final List<HouseCard> _houseCards = <HouseCard>[];

  String district = "",
      rentType = "",
      rooms = "",
      metroLine = "",
      metroStation = "",
      price1 = "",
      price2 = "";
  int page = 0, pageSize = 5;
  bool isLast = false;

  List<HouseCard> getHouseCard() {
    List<HouseCard> tmp = [];
    if (isLast) return tmp;
    for (int i = 0; i < 5; i++) {
      tmp.add(
        houseCardExample[Random().nextInt(houseCardExample.length)],
      );
    }
    return tmp;
  }

  Future getDatas() async {
    return Future.wait(
      [
        getHousePages(),
      ],
    );
  }

  Future<void> getHousePages() async {
    await fetchHousePage(district, price1, price2, rentType, rooms, metroLine,
            metroStation, page, pageSize)
        .then((value) => {
              debugPrint("fetchHousePage: "),
              debugPrint(jsonEncode(value.toJson())),
              value.content?.forEach((element) {
                debugPrint(jsonEncode(element.toJson()));
              }),
              value.content?.forEach((e) {
                _houseCards.add(e.toHouseCard());
              }),
              isLast = value.last!,
            });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              // shrinkWrap:true,  //加了这个HouseList外面就不用了加Container或Expanded了
              padding: const EdgeInsets.all(16.0),
              itemBuilder: /*1*/ (context, i) {
                if (i.isOdd) {
                  return const Divider();
                }
                /*2*/

                final index = i ~/ 2; /*3*/
                if (index >= _houseCards.length) {
                  _houseCards.addAll(
                    getHouseCard(),
                  ); /*4*/
                }
                return _houseCards[index];
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
