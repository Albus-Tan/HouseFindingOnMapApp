import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../service/backend_service/select_house.dart';
import 'house_card.dart';

class HouseListNearby extends StatefulWidget {
  // final Map<String, String>? filter;
  final String lat,lng;

  const HouseListNearby({
    // this.filter,
    this.lat = "",
    this.lng = "",
    Key? key,
  }) : super(key: key);

  @override
  State<HouseListNearby> createState() => _HouseListNearbyState();
}

class _HouseListNearbyState extends State<HouseListNearby> {
  final List<HouseCard> _houseCards = <HouseCard>[];
  final Set<int> hasFetched = {};
  int page = 0, pageSize = 10;
  int totElements = 0;

  bool _isLastPage = false, isLoading = false;

  Future<void> getPageOfHouseCard() async {
    if (_isLastPage || hasFetched.contains(page)) return;
    hasFetched.add(page);
    isLoading = true;
    await getHousePages();
  }

  Future<List<void>> getDatas() async {
    return await Future.wait(
      [
        getPageOfHouseCard(),
      ],
    );
  }

  Future<void> getHousePages() async {
    await fetchHousePageNearBy(
        widget.lat,
        widget.lng,
        page,
        pageSize)
        .then((value) => {
      debugPrint("fetchHousePageNearBy: $page ${value.last!}"),
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
      totElements = value.totalElements!,
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
            return ListView.separated(
              shrinkWrap: true,
              //加了这个HouseList外面就不用了加Container或Expanded了
              itemCount: totElements + 1,
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
                    if (index == _houseCards.length)
                      return const Text("已经到底部了~~");
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
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
