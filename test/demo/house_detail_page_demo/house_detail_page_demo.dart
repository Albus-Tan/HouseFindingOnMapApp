import 'package:app/routes/house_detail_page.dart';
import 'package:flutter/material.dart';

HouseDetail houseDetail = HouseDetail(
  title: '2号线淞虹路地铁站，精装修一房，房东人好，可以随时看房入住',
  pricePerMonth: 3800,
  squares: 40,
  direction: '南',
  shiNumber: 1,
  tingNumber: 1,
  weiNumber: 1,
  isStatic: true,
  image: "assets/house_detail_page_houses/house1.jpg",
  location: '',
  layout: '',
  hid: '',
  district: '',
  community: '',
  latitude: '',
  longitude: '',
);

class HouseDetailPageApp extends StatelessWidget {
  const HouseDetailPageApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'house page',
      home: HouseDetailPage(houseDetail: houseDetail),
    );
  }
}

void main() {
  runApp(const HouseDetailPageApp());
}
