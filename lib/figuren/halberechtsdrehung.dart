
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget halbeRechtsdrehung() {

  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Container(child: Text("Halbe Rechtsdrehung",
          style: TextStyle(color: Color(0xff01579B), fontSize: 24.0,fontWeight: FontWeight.bold),)),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                Container(child: Icon(
                  FontAwesomeIcons.solidStarHalf, color: Colors.amber,
                  size: 15.0,),),
              ],)),
      ),
      Container(child: Text("Grundlagen \u00B7 Langsamer Walzer ",
        style: TextStyle(color: Colors.black54, fontSize: 18.0,fontWeight: FontWeight.bold),)),
    ],
  );
}
