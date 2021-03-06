
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class routingItem extends StatefulWidget{

  StatefulWidget app;
  String path;
  Widget inhalt;

  routingItem(StatefulWidget app , Widget inhalt){
    app = app;
  }

  @override
  State<StatefulWidget> createState() {
    @override
    _routingItem createState() => _routingItem(app,inhalt,path);

  }}

class _routingItem extends State<routingItem> {
  StatefulWidget app;
  String path;
  Widget inhalt;

  _routingItem(StatefulWidget app,Widget inhalt,String path){
    app = app;
    path = path;
    inhalt = inhalt;

  }
  @override
  Widget build(BuildContext context) {
    GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => app),);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: new FittedBox(
            child: Material(
                color: Colors.white,
                elevation: 14.0,
                borderRadius: BorderRadius.circular(24.0),
                shadowColor: Color(0x802196F3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: inhalt,
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 10, bottom: 10),
                      width: 250,
                      height: 200,
                      child: ClipRRect(
                        borderRadius: new BorderRadius.circular(24.0),
                        child: Image(
                          fit: BoxFit.contain,
                          alignment: Alignment.topRight,
                          image: AssetImage(
                              path),
                        ),),)
                  ],)
            ),
          ),
        ),
      ),

    );

  }
}
