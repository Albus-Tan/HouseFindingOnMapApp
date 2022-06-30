import 'package:app/routes/home_page.dart';
import 'package:app/widgets/carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  testWidgets('Widget home page test', (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // necessary for http request
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      await tester.pump();
      expect(find.widgetWithText(Expanded, '搜租房'), findsOneWidget);
      expect(find.text('点击图标搜索小区'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);

      //测试 Tab
      expect(find.byType(Tab), findsNWidgets(4));
      expect(find.text('推荐'), findsOneWidget);
      expect(find.text('附近'), findsOneWidget);
      expect(find.text('整租'), findsOneWidget);
      expect(find.text('合租'), findsOneWidget);
      expect(find.byKey(const Key('recommendTabView')), findsOneWidget);
      expect(find.byKey(const Key('nearbyTabView')), findsNothing);
      expect(find.byKey(const Key('rentWholeTabView')), findsNothing);
      expect(find.byKey(const Key('rentTogetherTabView')), findsNothing);
      await tester.tap(find.text('附近'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('recommendTabView')), findsNothing);
      expect(find.byKey(const Key('nearbyTabView')), findsOneWidget);
      expect(find.byKey(const Key('rentWholeTabView')), findsNothing);
      expect(find.byKey(const Key('rentTogetherTabView')), findsNothing);
      await tester.drag(find.byKey(const Key('nearbyTabView')), const Offset(-500.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('recommendTabView')), findsNothing);
      expect(find.byKey(const Key('nearbyTabView')), findsNothing);
      expect(find.byKey(const Key('rentWholeTabView')), findsOneWidget);
      expect(find.byKey(const Key('rentTogetherTabView')), findsNothing);

      // 测试 Carousel
      expect(find.byType(Carousel), findsOneWidget);
      expect(find.text('海量房源'), findsNothing);
      expect(find.text('启航租房节'), findsOneWidget);
      await tester.drag(find.byKey(const Key('home page Carousel')), const Offset(-500.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.text('海量房源'), findsOneWidget);
      expect(find.text('启航租房节'), findsNothing);

      // 测试搜索跳转
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      expect(find.text('房源推荐'), findsOneWidget);
      expect(find.text('历史记录'), findsOneWidget);
      
    });
  });
}
