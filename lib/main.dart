import 'package:app/house_list_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(key: key);

  static const String _title = 'Demo';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: Scaffold(
        // appBar: AppBar(title: const Text(_title)),
        body: HouseListPage(),
      ),
    );
  }
}
