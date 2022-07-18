import 'package:flutter/material.dart';

import '../routes/house_detail_page.dart';
import '../widgets/house_card.dart';

Widget houseDetailToHouseList(List<HouseDetail> list) {
  List<HouseCard> houseCards;
  int totElements = list.length;
  houseCards = list.map((e) => HouseCard(houseDetail: e)).toList();
  return ListView.separated(
    shrinkWrap: true,
    itemCount: totElements + 1,
    padding: const EdgeInsets.all(16.0),
    itemBuilder: (context, index) {
      if (index == houseCards.length) return const Text("已经到底部了~~");
      return houseCards[index];
    },
    separatorBuilder: (BuildContext context, int index) {
      return const Divider();
    },
  );
}
