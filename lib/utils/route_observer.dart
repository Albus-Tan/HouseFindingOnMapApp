import 'package:flutter/material.dart';

///导航栈的变化监听
class AppNavigatorObserver extends NavigatorObserver{

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    String? previousName = '';
    if (previousRoute == null) {
      previousName = 'null';
    }else {
      previousName = previousRoute.settings.name;
    }
    print('YM----->NavObserverDidPop--Current:${route.settings.name ?? ''}   Previous:$previousName');
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    var previousName = '';
    if (previousRoute == null) {
      previousName = 'null';
    }else {
      previousName = previousRoute.settings.name ?? '';
    }
    print('YM-------NavObserverDidPush-Current:${route.settings.name ?? ''}  Previous:$previousName');

  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
  }

  @override
  void didStartUserGesture(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    super.didStartUserGesture(route!, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute,oldRoute: oldRoute);
  }

  @override
  void didRemove(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    super.didRemove(route!, previousRoute);
  }
}
