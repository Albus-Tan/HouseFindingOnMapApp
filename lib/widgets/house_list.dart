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
      price2,
      keyword;

  const HouseList({
    // this.filter,
    this.district = "",
    this.rentType = "",
    this.rooms = "",
    this.metroLine = "",
    this.metroStation = "",
    this.price1 = "",
    this.price2 = "",
    this.keyword = "",
    Key? key,
  }) : super(key: key);

  @override
  State<HouseList> createState() => _HouseListState();
}

class _HouseListState extends State<HouseList> {
  final _houseCards = <HouseCard>[];
  final hasFetched = <int>{};
  var page = 0;
  final pageSize = 10;
  var totElements = 0;
  var cachedElements = 0;
  var _isLastPage = false;
  var isLoading = false;

  Future<void> getHouses(int page) async {
    if (_isLastPage) return;
    await fetchHousePage(
            widget.district,
            widget.price1,
            widget.price2,
            widget.rentType,
            widget.rooms,
            widget.metroLine,
            widget.metroStation,
            widget.keyword,
            page,
            pageSize)
        .then((value) {
      value.content?.forEach(
        (e) {
          _houseCards.add(
            e.toHouseCard(),
          );
        },
      );
      // debugPrint("fetchHousePage: $page $_houseCards"),
      setState(() {
        _isLastPage = value.last!;
        this.page = page;
        totElements = value.totalElements!;
        cachedElements += 10;
        isLoading = false;
      });
    });
  }

  Future<void> init() async {
    await fetchHousePage(
            widget.district,
            widget.price1,
            widget.price2,
            widget.rentType,
            widget.rooms,
            widget.metroLine,
            widget.metroStation,
            widget.keyword,
            page,
            pageSize)
        .then((value) {
      value.content?.forEach(
        (e) {
          _houseCards.add(
            e.toHouseCard(),
          );
        },
      );
      _isLastPage = value.last!;
      page = 0;
      totElements = value.totalElements!;
      cachedElements = 10;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      //加了这个HouseList外面就不用了加Container或Expanded了
      itemCount: cachedElements + 1,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        if (index < cachedElements) {
          return _houseCards[index];
        } else {
          getHouses(page + 1);
          return Text("loading");
        }
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }
}
