import 'package:app/routes/house_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'house_detail_page_demo.dart';

void main() {
  testWidgets('Widget test', (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // necessary for http request
      await tester.pumpWidget(const HouseDetailPageApp());
      await tester.pump();

      expect(
          find.text('${houseDetail.shiNumber}室'
              '${houseDetail.tingNumber}厅'
              '${houseDetail.weiNumber}卫'),
          findsOneWidget);
      expect(find.text('${houseDetail.squares}平'), findsOneWidget);
      expect(find.text(houseDetail.direction), findsOneWidget);
      //expect(find.text(houseDetail.pricePerMonth.toString()), findsOneWidget);
      // await expectLater(find.text(
      //     '${houseDetail.squares}平'), matchesGoldenFile('squares.png'));
      final Finder favorite =
          find.byKey(const ValueKey('detail_favorite_button'));
      await tester.tap(favorite);

      final Finder search = find.byKey(const ValueKey('detail_search_button'));
      await tester.tap(search);

      final Finder buttons =
          find.byKey(const ValueKey('detail_bottom_buttons'));
      await tester.tap(buttons);

      final Finder navigator =
          find.byKey(const ValueKey("detail_navigation_icon"));
      await tester.tap(navigator);
    });
  });
}
