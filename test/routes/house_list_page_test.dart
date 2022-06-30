import 'package:app/routes/house_detail_page.dart';
import 'package:app/routes/house_list_page.dart';
import 'package:app/widgets/house_card.dart';
import 'package:app/widgets/house_list.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  testWidgets('Widget test', (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // necessary for http request
      await tester.pumpWidget(const MaterialApp(
        home: HouseListPage(),
      ));
      await tester.pump();

      expect(find.bySubtype<HouseList>(), findsOneWidget);
      expect(find.bySubtype<BrnAppBar>(), findsOneWidget);
      expect(find.bySubtype<BrnSelectionView>(), findsOneWidget);

      expect(find.bySubtype<HouseCard>(), findsWidgets);
      final card = find.bySubtype<HouseCard>().first;
      await tester.tap(card);
      for (int i = 0; i < 3; i++) {
        await tester.pump(Duration(seconds: 1));
      }

      //跳转到detail
      expect(find.bySubtype<HouseDetailPage>(), findsOneWidget);
      expect(find.byType(Image), findsWidgets);
      await tester.drag(find.byType(PageView), const Offset(-500.0, 0.0));
      for (int i = 0; i < 3; i++) {
        await tester.pump(Duration(seconds: 1));
      }
    });
  });
  testWidgets('Widget test 2', (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // necessary for http request
      await tester.pumpWidget(const MaterialApp(
        home: HouseListPage(),
      ));
      await tester.pump();

      expect(find.bySubtype<HouseList>(), findsOneWidget);
      expect(find.bySubtype<BrnAppBar>(), findsOneWidget);
      // expect(find.byElementType(BrnSelectionView), findsOneWidget);

      final search = find.bySubtype<BrnIconAction>().first;
      await tester.tap(search);
    });
  });
}
