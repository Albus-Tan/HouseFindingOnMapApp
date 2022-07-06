import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import '../widgets/house_detail_bottom_sheet_on_map.dart';
import '../widgets/map.dart';
import '../widgets/map/reducer.dart';
import '../widgets/map/state.dart';

class MapFindPage extends StatefulWidget {
  const MapFindPage({Key? key}) : super(key: key);

  @override
  State<MapFindPage> createState() => _MapFindPageState();
}

class _MapFindPageState extends State<MapFindPage> {
  late Store<MapState> store;

  @override
  void initState() {
    super.initState();
    store = Store(mapReducer, initialState: MapState.initialState());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
       MapWidget(),
        Column(
          children: const [
            Text('这是为了占用空间的一行字'),
            HouseDetailBottomSheet(),
          ],
        ),
      ],
    );
  }
}
