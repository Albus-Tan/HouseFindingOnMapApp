import 'package:app/routes/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../demo/house_detail_page_demo/house_detail_page_demo.dart';

void main() {
  testWidgets('Widget home page search test', (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // necessary for http request
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      await tester.pump();
      expect(find.byIcon(Icons.search), findsOneWidget);

      // 测试搜索跳转
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      expect(find.text('房源推荐'), findsOneWidget);
      expect(find.text('历史记录'), findsOneWidget);

      await tester.enterText(find.byType(EditableText),'s');
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('sss')), findsOneWidget);
      expect(find.byKey(const Key('sousuo')), findsOneWidget);
      expect(find.byKey(const Key('sobk')), findsOneWidget);

      await tester.enterText(find.byType(EditableText),'so');
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('sss')), findsNothing);
      expect(find.byKey(const Key('sousuo')), findsOneWidget);
      expect(find.byKey(const Key('sobk')), findsOneWidget);

      await tester.enterText(find.byType(EditableText),'sob');
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('sss')), findsNothing);
      expect(find.byKey(const Key('sousuo')), findsNothing);
      expect(find.byKey(const Key('sobk')), findsOneWidget);

      await tester.tap(find.byKey(const Key('sobk')));
      for(int i = 0; i < 3; ++i){
        await tester.pump(const Duration(seconds: 1));
      }
      expect(find.text('房源推荐'), findsNothing);
      expect(find.text('历史记录'), findsNothing);
      expect(find.text('地区'), findsOneWidget);
      expect(find.text('租金'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();
      expect(find.text('房源推荐'), findsOneWidget);
      expect(find.text('历史记录'), findsOneWidget);
      expect(find.text('地区'), findsNothing);
      expect(find.text('租金'), findsNothing);

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      await tester.tap(find.text('汤臣一品').first);
      await tester.pumpAndSettle();

    });
  });
  testWidgets('Widget detail page search test', (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // necessary for http request
      await tester.pumpWidget(const HouseDetailPageApp());
      await tester.pump();
      expect(find.byIcon(Icons.search), findsOneWidget);

      // 测试搜索跳转
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      expect(find.text('房源推荐'), findsOneWidget);
      expect(find.text('历史记录'), findsOneWidget);

    });
  });
}
