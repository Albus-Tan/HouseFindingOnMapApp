import 'package:flutter/material.dart';

class ResidentialMapFindMarker extends StatelessWidget {
  ResidentialMapFindMarker(
      {Key? key, required this.residential, required this.num})
      : super(key: key);

  String residential;
  int num;
  bool focus = false;
  bool inPolygon = false;
  final focusedTextColor = Colors.white;
  final focusedBackgroundColor = Colors.redAccent;
  final normalTextColor = Colors.black;
  final normalBackgroundColor = Colors.white;
  final inPolygonTextColor = Colors.white;
  final inPolygonBackgroundColor = Colors.orangeAccent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: focus
            ? focusedBackgroundColor
            : (inPolygon ? inPolygonBackgroundColor : normalBackgroundColor),
        borderRadius: const BorderRadius.all(Radius.circular(30.0)),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Text.rich(
          TextSpan(
            children: [
              // WidgetSpan(child: Icon(Icons.home)),
              TextSpan(
                text: residential,
                style: TextStyle(
                    color: focus
                        ? focusedTextColor
                        : (inPolygon ? inPolygonTextColor : normalTextColor),
                    fontSize: 35),
              ),
              const TextSpan(
                text: " | ",
                style: TextStyle(color: Colors.grey, fontSize: 35),
              ),
              TextSpan(
                text: "$num套",
                style: TextStyle(
                    color: focus
                        ? focusedTextColor
                        : (inPolygon ? inPolygonTextColor : normalTextColor),
                    fontSize: 35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
