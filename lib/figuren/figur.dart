
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget figur(  String name,
String beschreibung,
int stars) {



  List<Widget> starListCreator(int stars){
    List<Widget> starList = [];
    for(int i = 0; i <stars;i++){
      starList.add(Container(child: Icon(
        FontAwesomeIcons.solidStar, color: Colors.amber,
        size: 15.0,),));
    }
    return starList;
  }


  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Container(child: Text(name,
          style: TextStyle(color: Color(0xff01579B), fontSize: 24.0,fontWeight: FontWeight.bold),)),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: starListCreator(stars),)),
      ),
      Container(child: Text(beschreibung,
        style: TextStyle(color: Colors.black54, fontSize: 18.0,fontWeight: FontWeight.bold),)),
    ],
  );
}