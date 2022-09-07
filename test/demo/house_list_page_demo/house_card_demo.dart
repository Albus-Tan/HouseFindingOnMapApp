import 'package:app/routes/house_detail_page.dart';
import 'package:app/widgets/house_card.dart';
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
        body:HouseCard(
          houseDetail: HouseDetail(
            location: '',
            district: '',
            pricePerMonth: 100,
            hid: '',
            community: '',
            squares: 100,
            longitude: '',
            layout: '',
            shiNumber: 1,
            latitude: '',
            title: '',
          ),
        ),
      ),
    );
  }
}
