import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const HouseCard(
          title: "城东刚需好房 东城名苑 精装 房东诚心出售",
          rooms: 3,
          squares: 89,
          community: "荣安美安府",
          price: 2000,
          url:
              "https://pic1.ajkimg.com/display/58ajk/bb2ea992a99e20c0eadf28414065f95d/640x420c.jpg?t=1",
        ),
      ),
    );
  }
}

class HouseCard extends StatelessWidget {
  const HouseCard({
    Key? key,
    required this.title,
    required this.rooms,
    required this.squares,
    required this.community,
    required this.price,
    required this.url,
  }) : super(key: key);

  final String title;
  final int rooms;
  final double squares;
  final String community;
  final int price;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Image.network(url),
              onTap: (){
                print("onTap");  //后面改成页面的跳转
              },
              title: BrnExpandableText(
                text: title,
                textStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
                maxLines: 2,
              ),
              subtitle: RichText(
                  text: TextSpan(
                      text: '$rooms室·$squares平·$community',
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      children: [
                    TextSpan(
                        text: '\n$price元/月',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ))
                  ])),
            )
          ],
        ),
      ),
    );
  }
}
