import 'package:app/routes/home_page.dart';
import 'package:app/routes/house_detail_page.dart';
import 'package:app/routes/house_list_page.dart';
import 'package:app/widgets/carousel.dart';
import 'package:app/widgets/house_card.dart';
import 'package:app/widgets/house_list.dart';
import 'package:app/widgets/map/reducer.dart';
import 'package:app/widgets/map/state.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:redux/redux.dart';

import 'demo/house_detail_page_demo/house_detail_page_demo.dart';

void main() {
  Store<MapState> store = Store(
    mapReducer,
    initialState: MapState.initialState(),
  );

  group('all test', () {
    testWidgets(
      'house list page test 1',
      (WidgetTester tester) async {
        mockNetworkImagesFor(
          () async {
            // necessary for http request
            await tester.pumpWidget(
              const MaterialApp(
                home: HouseListPage(),
              ),
            );
            await tester.pump();

            expect(find.bySubtype<HouseList>(), findsOneWidget);
            expect(find.bySubtype<BrnAppBar>(), findsOneWidget);
            expect(find.bySubtype<BrnSelectionView>(), findsOneWidget);
            expect(find.text("地区"), findsOneWidget);

            expect(find.bySubtype<HouseCard>(), findsWidgets);
            final card = find.bySubtype<HouseCard>().first;
            await tester.tap(card);
            for (int i = 0; i < 3; i++) {
              await tester.pump(
                Duration(
                  seconds: 1,
                ),
              );
            }

            //跳转到detail
            expect(find.bySubtype<HouseDetailPage>(), findsOneWidget);
            expect(find.byType(Image), findsWidgets);
            await tester.drag(find.byType(PageView), const Offset(-500.0, 0.0));
            for (int i = 0; i < 3; i++) {
              await tester.pump(
                Duration(
                  seconds: 1,
                ),
              );
            }
          },
        );
      },
    );
    testWidgets(
      'house list page test 2',
      (WidgetTester tester) async {
        mockNetworkImagesFor(
          () async {
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
          },
        );
      },
    );
    testWidgets('home page test 1', (WidgetTester tester) async {
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
        await tester.drag(
            find.byKey(const Key('nearbyTabView')), const Offset(-500.0, 0.0));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('recommendTabView')), findsNothing);
        expect(find.byKey(const Key('nearbyTabView')), findsNothing);
        expect(find.byKey(const Key('rentWholeTabView')), findsOneWidget);
        expect(find.byKey(const Key('rentTogetherTabView')), findsNothing);

        // 测试 Carousel
        expect(find.byType(Carousel), findsOneWidget);
        expect(find.text('海量房源'), findsNothing);
        expect(find.text('启航租房节'), findsOneWidget);
        await tester.drag(find.byKey(const Key('home page Carousel')),
            const Offset(-500.0, 0.0));
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
        final Finder search =
            find.byKey(const ValueKey('detail_search_button'));
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
        await tester.pumpWidget(StoreProvider(
          store: store,
          child: HouseDetailPageApp(),
        ));
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

        await tester.enterText(find.byType(EditableText), 's');
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('sss')), findsOneWidget);
        expect(find.byKey(const Key('sousuo')), findsOneWidget);
        expect(find.byKey(const Key('sobk')), findsOneWidget);

        await tester.enterText(find.byType(EditableText), 'so');
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('sss')), findsNothing);
        expect(find.byKey(const Key('sousuo')), findsOneWidget);
        expect(find.byKey(const Key('sobk')), findsOneWidget);

        await tester.enterText(find.byType(EditableText), 'sob');
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('sss')), findsNothing);
        expect(find.byKey(const Key('sousuo')), findsNothing);
        expect(find.byKey(const Key('sobk')), findsOneWidget);

        await tester.tap(find.byKey(const Key('sobk')));
        await tester.pumpAndSettle();
        expect(find.text('房源推荐'), findsNothing);
        expect(find.text('历史记录'), findsNothing);
        // expect(find.text('地区'), findsOneWidget);
        // expect(find.text('租金'), findsOneWidget);

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
  });
}
