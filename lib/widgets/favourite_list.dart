import 'package:flutter/material.dart';
import 'house_card.dart';

class FavouriteList extends StatefulWidget {

  const FavouriteList({
    Key? key,
  }) : super(key: key);

  @override
  State<FavouriteList> createState() => _FavouriteListState();
}

class _FavouriteListState extends State<FavouriteList> {
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

  Future<void> getPageOfFavouriteHouseCard() async {
    if (_isLastPage || hasFetched.contains(page)) return;
    hasFetched.add(page);
    isLoading = true;
    await getFavourites();
  }

  Future getDatas() async {
    return Future.wait(
      [
        getPageOfFavouriteHouseCard(),
      ],
    );
  }

  Future<void> getFavourites() async {
    // await fetchHousePage(
    //     widget.district,
    //     widget.price1,
    //     widget.price2,
    //     widget.rentType,
    //     widget.rooms,
    //     widget.metroLine,
    //     widget.metroStation,
    //     page,
    //     pageSize)
    //     .then((value) => {
    //   debugPrint("fetchHousePage: $page ${value.last!}"),
    //   // debugPrint(jsonEncode(value.toJson())),
    //   // value.content?.forEach((element) {
    //   //   debugPrint(jsonEncode(element.toJson()));
    //   // }),
    //
    //   value.content?.forEach((e) {
    //     _houseCards.add(e.toHouseCard());
    //   }),
    //   // debugPrint("fetchHousePage: $page $_houseCards"),
    //   _isLastPage = value.last!,
    //   isLoading = false,
    //   page++,
    // });
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
              // shrinkWrap:true,  //加了这个HouseList外面就不用了加Container或Expanded了
              // itemCount: _houseCards.length + (_isLastPage ? 0 : 1),
              padding: const EdgeInsets.all(16.0),
              itemBuilder: /*1*/ (context, i) {
                if (i.isOdd) {
                  return const Divider();
                }
                /*2*/

                final index = i ~/ 2; /*3*/
                if (index >= _houseCards.length) {
                  getPageOfFavouriteHouseCard();
                  // _houseCards.addAll(
                  //   getHouseCard(),
                  // ); /*4*/
                }
                // while (isLoading);
                if (_isLastPage && index >= _houseCards.length) {
                  return const Text("Over~");
                }
                if (index >= _houseCards.length && isLoading) {
                  return const Text("Loading~");
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
