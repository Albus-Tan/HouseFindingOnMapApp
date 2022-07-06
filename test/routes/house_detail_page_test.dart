import 'package:app/widgets/map/reducer.dart';
import 'package:app/widgets/map/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:redux/redux.dart';

import '../demo/house_detail_page_demo/house_detail_page_demo.dart';

void main() {
  Store<MapState> store = Store(
    mapReducer,
    initialState: MapState.initialState(),
  );

  testWidgets('test search flow', (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // necessary for http request
      await tester.pumpWidget(const HouseDetailPageApp());
      await tester.pumpAndSettle();

      // unit test
      expect(
          find.text('${houseDetail.shiNumber}室'
              '${houseDetail.tingNumber}厅'
              '${houseDetail.weiNumber}卫'),
          findsOneWidget);
      expect(find.text('${houseDetail.squares}平'), findsOneWidget);
      expect(find.text(houseDetail.direction), findsOneWidget);
      //expect(find.text(houseDetail.pricePerMonth.toString()), findsOneWidget);

      // click favorite button
      final Finder favorite =
          find.byKey(const ValueKey('detail_favorite_button'));
      expect(favorite, findsOneWidget);
      await tester.tap(favorite);
      await tester.pumpAndSettle();

      // click search button
      final Finder search = find.byKey(const ValueKey('detail_search_button'));
      await tester.tap(search);
      await tester.pumpAndSettle();

      // skip to search page
      expect(
          find.text('${houseDetail.shiNumber}室'
              '${houseDetail.tingNumber}厅'
              '${houseDetail.weiNumber}卫'),
          findsNothing);
      expect(find.text('${houseDetail.squares}平'), findsNothing);
      expect(find.text(houseDetail.direction), findsNothing);
      expect(find.text(houseDetail.pricePerMonth.toString()), findsNothing);

      // final Finder buttons =
      //     find.byKey(const ValueKey('detail_bottom_buttons'));
      // await tester.tap(buttons);
      //

      // golden test
      //  await expectLater(find.text(
      //      '${houseDetail.squares}平'), matchesGoldenFile('squares.bmp'));
      //  await tester.pump();
      // await expectLater(find.text(
      //     houseDetail.direction), matchesGoldenFile('squares.png'));
    });
  });

  testWidgets("test navigation button", (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        StoreProvider(
          store: store,
          child: HouseDetailPageApp(),
        ),
      );
      await tester.pumpAndSettle();

      // unit test
      expect(
          find.text('${houseDetail.shiNumber}室'
              '${houseDetail.tingNumber}厅'
              '${houseDetail.weiNumber}卫'),
          findsOneWidget);
      expect(find.text('${houseDetail.squares}平'), findsOneWidget);
      expect(find.text(houseDetail.direction), findsOneWidget);

      final Finder navigator =
          find.byKey(const ValueKey("detail_navigation_icon"));
      await tester.tap(navigator);
      await tester.pumpAndSettle();

      expect(
          find.text('${houseDetail.shiNumber}室'
              '${houseDetail.tingNumber}厅'
              '${houseDetail.weiNumber}卫'),
          findsNothing);
      expect(find.text('${houseDetail.squares}平'), findsNothing);
      expect(find.text(houseDetail.direction), findsNothing);
      expect(find.text(houseDetail.pricePerMonth.toString()), findsNothing);
    });
  });
}
