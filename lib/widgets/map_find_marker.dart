import 'package:flutter/material.dart';

class ResidentialMapFindMarker extends StatelessWidget {

  ResidentialMapFindMarker({Key? key, required this.residential, required this.num}) : super(key: key);

  String residential;
  int num;
  bool focus = false;
  final focusedTextColor = Colors.white;
  final focusedBackgroundColor = Colors.redAccent;
  final unfocusedTextColor = Colors.black;
  final unfocusedBackgroundColor = Colors.white;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: focus ? focusedBackgroundColor : unfocusedBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(30.0)),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Text.rich(
          TextSpan(
            children: [
              // WidgetSpan(child: Icon(Icons.home)),
              TextSpan(text: residential, style: TextStyle(color: focus ? focusedTextColor : unfocusedTextColor, fontSize: 35),),
              const TextSpan(
                text: " | ",
                style: TextStyle(color: Colors.grey, fontSize: 35),
              ),
              TextSpan(text: "$num套", style: TextStyle(color: focus ? focusedTextColor : unfocusedTextColor, fontSize: 35),),
            ],
          ),
        ),
      ),
    );
  }
}


