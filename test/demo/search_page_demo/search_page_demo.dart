import 'package:app/routes/search_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(const AppWrapper());

class AppWrapper extends StatelessWidget {
  const AppWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Name"),
        leading: Builder(
          builder: (context) {
            return IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: SearchBarViewDelegate());
                },
            );
          },
        ),
      ),
    );
  }
}
