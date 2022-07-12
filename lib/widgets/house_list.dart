import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../service/backend_service/select_house.dart';
import 'house_card.dart';

class HouseList extends StatefulWidget {
  // final Map<String, String>? filter;
  final String district,
      rentType,
      rooms,
      metroLine,
      metroStation,
      price1,
      price2;

  const HouseList({
    // this.filter,
    this.district = "",
    this.rentType = "",
    this.rooms = "",
    this.metroLine = "",
    this.metroStation = "",
    this.price1 = "",
    this.price2 = "",
    Key? key,
  }) : super(key: key);

  @override
  State<HouseList> createState() => _HouseListState();
}

class _HouseListState extends State<HouseList> {
  final List<HouseCard> _houseCards = <HouseCard>[];
  final Set<int> hasFetched = {};
  int page = 0, pageSize = 10;

  bool _isLastPage = false, isLoading = false;

  // List<HouseCard> getHouseCard() {
  //   List<HouseCard> tmp = [];
  //   if (isLast) return tmp;
  //   for (int i = 0; i < 5; i++) {
  //     tmp.add(
  //       houseCardExample[Random().nextInt(houseCardExample.length)],
  //     );
  //   }
  //   return tmp;
  // }

  Future<void> getPageOfHouseCard() async {
    if (_isLastPage || hasFetched.contains(page)) return;
    hasFetched.add(page);
    isLoading = true;
    await getHousePages();
  }

  Future getDatas() async {
    return Future.wait(
      [
        getPageOfHouseCard(),
      ],
    );
  }

  Future<void> getHousePages() async {
    await fetchHousePage(
            widget.district,
            widget.price1,
            widget.price2,
            widget.rentType,
            widget.rooms,
            widget.metroLine,
            widget.metroStation,
            page,
            pageSize)
        .then((value) => {
              debugPrint("fetchHousePage: $page ${value.last!}"),
              // debugPrint(jsonEncode(value.toJson())),
              // value.content?.forEach((element) {
              //   debugPrint(jsonEncode(element.toJson()));
              // }),

              value.content?.forEach((e) {
                _houseCards.add(e.toHouseCard());
              }),
              // debugPrint("fetchHousePage: $page $_houseCards"),
              _isLastPage = value.last!,
              isLoading = false,
              page++,
            });
  }

  @override
  Widget build(BuildContext context) {
    _houseCards.clear();
    hasFetched.clear();
    page = 0;
    _isLastPage = isLoading = false;
    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              shrinkWrap: true, //加了这个HouseList外面就不用了加Container或Expanded了
              // itemCount: _houseCards.length + (_isLastPage ? 0 : 1),
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) {
                if (index >= _houseCards.length) {
                  getPageOfHouseCard();
                  // _houseCards.addAll(
                  //   getHouseCard(),
                  // ); /*4*/
                }
                // while (isLoading);
                if (index >= _houseCards.length) {
                  if (_isLastPage) {
                    if (index == _houseCards.length) return const Text("已经到底部了~~");
                    return const Divider();
                  }
                  if (isLoading) {
                    if (index == _houseCards.length) {
                      return Text("Loading~");
                    }
                    return const Divider();
                  }
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
