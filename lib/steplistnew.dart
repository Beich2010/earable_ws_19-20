import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dio/dio.dart';

import 'package:mobile_computing_earable/figuren/figur.dart';
import 'package:mobile_computing_earable/figuren/nonroutingItem.dart';
import 'package:mobile_computing_earable/figuren/routingItem.dart';
import 'package:mobile_computing_earable/figuren/halberechtsdrehung.dart';
import 'package:mobile_computing_earable/figuren/halbelinksdrehung.dart';
import 'package:mobile_computing_earable/figuren/telemark.dart';
import 'package:mobile_computing_earable/figuren/halberechtsdrehung.dart';
import 'package:mobile_computing_earable/figuren/throwawayoversway.dart';
import 'package:mobile_computing_earable/figuren/turningLocktoRight.dart';
import 'package:mobile_computing_earable/test.dart';
import 'package:mobile_computing_earable/halbe_rechtsdrehung_funktion.dart';
import 'package:mobile_computing_earable/flutterexample.dart';
import 'package:esense_flutter/esense.dart';

import 'figuren/testfigur.dart';

class StepList extends StatefulWidget {
  @override
  _StepList createState() => _StepList();
}

class Item {
  Widget w;
  String key;
  List<String> list;

  Item(String name, list, Widget widget) {
    w = widget;
    list = list;
    key = name;
  }
}

class _StepList extends State<StepList> {
  Widget _appBarTitle = new Text('Suchen...');
  Icon _searchIcon = new Icon(Icons.search);
  String filter;
  List<Item> itemList;
  TextEditingController controller = new TextEditingController();

  bool Lw = true;
  bool Tg = true;
  bool Vw = true;
  bool Sf = true;
  bool Qs = true;

  IconData _deviceStatus = IconData(57770, fontFamily: 'MaterialIcons');
  Color _connectedColor = Colors.red;

  Timer T1;
  EsenseConnector Connector;
  Settings Config;

  @override
  initState() {
    Connector = EsenseConnector();
    Config = Settings();
    //Wiener Walzer

    Item fL = new Item(
        'Fleckerl',
        ["WienerWalzer"],
        nonroutingItem(figur('Fleckerl', "Grundlagen \u00B7 Wiener Walzer", 5),
            'graphics/logo.png'));

    //Quickstep

    Item fuenf = new Item(
        'Fünferlauf',
        ["Quickstep"],
        nonroutingItem(figur('Fünferlauf', "Grundlagen \u00B7 Quickstep", 1),
            'graphics/logo.png'));

    //Slowfox

    Item fE = new Item(
        'Federschritt',
        ["Slowfox"],
        nonroutingItem(figur('Federschritt', "Grundlagen \u00B7 Slowfox", 1),
            'graphics/logo.png'));

    // Tango
    Item pR = new Item(
        'Promenaden Rechtsdrehung',
        ["Tango"],
        nonroutingItem(
            figur('Promenaden Rechtsdrehung', "Grundlagen \u00B7 Tango ", 1),
            'graphics/logo.png'));

    Item kE = new Item(
        'Kehre',
        ["Tango"],
        nonroutingItem(
            figur('Kehre', "        Grundlagen \u00B7 Tango         ", 2),
            'graphics/logo.png'));

    Item cC = new Item(
        'ContraCheck',
        ["Tango"],
        nonroutingItem(
            figur('Contra Check', "          Posen \u00B7 Tango         ", 4),
            'graphics/logo.png'));

    // Langsamer Walzer

    Item hR = new Item(
        "Halbe Rechtsdrehung",
        ["Langsamer Walzer"],
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new MyApp(Connector, Config)),
            );
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
                            child: halbeRechtsdrehung(),
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
                                  'graphics/halbe_rechtsdrehung.png'),
                            ),
                          ),
                        )
                      ],
                    )),
              ),
            ),
          ),
        ));

    Item hL = new Item(
        'Halbe Linksdrehung',
        ["LangsamerWalzer"],
        nonroutingItem(
            figur(
                "Halbe Linksdrehung", "Grundlagen \u00B7 Langsamer Walzer ", 2),
            'graphics/logo.png'));

    Item tO = new Item(
        'Throwaway Oversway',
        ["LangsamerWalzer"],
        nonroutingItem(
            figur(
                "Throwaway Oversway", "Grundlagen \u00B7 Langsamer Walzer ", 2),
            'graphics/logo.png'));

    Item tM = new Item(
        'Telemark',
        ["LangsamerWalzer"],
        nonroutingItem(
            figur("Telemark", "Grundlagen \u00B7 Langsamer Walzer ", 2),
            'graphics/logo.png'));

    Item tL = new Item(
        'Turning Lock nach Rechts',
        ["LangsamerWalzer"],
        nonroutingItem(
            figur("Turning Lock nach Rechts",
                "Grundlagen \u00B7 Langsamer Walzer ", 2),
            'graphics/logo.png'));

    // Test Bench

    Item test = new Item(
        "Testbench",
        ["Testing"],
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TestApp()),
            );
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
                            child: testfigur(),
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
                              image: AssetImage('graphics/logo.png'),
                            ),
                          ),
                        )
                      ],
                    )),
              ),
            ),
          ),
        ));

    itemList = [hL, hR, tL, tM, tO, pR, kE, cC, fL, fuenf, fE, test];
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
    getESensePropertiesfromConnector();
  }

  void getESensePropertiesfromConnector() async {
    // get every 2 secs
    T1 = Timer.periodic(Duration(seconds: 10), (timer) async => refresh());
  }

  void refresh() async {
    if (mounted) {
      setState(() {
        _deviceStatus = Connector.deviceStatus;
        _connectedColor = Connector.connectedColor;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: new ListView.builder(
        itemCount: itemList.length,
        itemBuilder: (BuildContext context, int index) {
          return filter == null || filter == ""
              ? new Container(child: itemList[index].w)
              : itemList[index].key.toLowerCase().contains(filter.toLowerCase())
                  ? new Container(child: itemList[index].w)
                  : new Container();
        },
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
        centerTitle: true,
        title: _appBarTitle,
        leading: new IconButton(
          icon: _searchIcon,
          onPressed: _searchPressed,
        ),
        actions: <Widget>[
          Container(
            child: new IconButton(
              icon: Icon(_deviceStatus, color: _connectedColor),
              onPressed: () {
                if (Connector.deviceStatus ==
                    IconData(57769, fontFamily: 'MaterialIcons')) {
                  Connector.connectToESense();
                }
              },
            ),
          ),



        ]);
  }

  @override
  void dispose() {

    controller.dispose();
    super.dispose();
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close,color: Color(0xFFFFFFFF));
        this._appBarTitle = new TextField(
          cursorColor: Colors.white,
          style: TextStyle(fontSize: 17.0, color: Colors.white),
          controller: controller,
          decoration: new InputDecoration(
              hintStyle: TextStyle(fontSize: 17.0, color: Colors.white),
              prefixIcon: new Icon(Icons.search ,color: Color(0xFFFFFFFF)), hintText: 'Suchen...'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search ,color: Color(0xFFFFFFFF));
        this._appBarTitle = new Text('Suchen...');
        this.filter = null;
      }
    });
  }
}

class EsenseConnector {
  EsenseConnector() {
    connectToESense();
  }

  IconData deviceStatus = IconData(57770, fontFamily: 'MaterialIcons');
  IconData batteryStatus =
      IconData(57766, fontFamily: 'MaterialIcons', matchTextDirection: true);
  Color connectedColor = Colors.red;
  Color batteryColor = Colors.grey;

  bool con = false;

  Timer _T1;
  Timer _T2;
  Timer _T3;
  Timer _T4;
  Timer _T5;

  StreamSubscription subscription;

  bool _sampling = false;

  String _event = '';

  List<DateTime> data_time = [];

  // the name of the eSense device to connect to -- change this to your own device.
  String eSenseName = 'eSense-0569';

  @override
  void initState() {
    connectToESense();
  }

  Future<void> connectToESense() async {
    // if you want to get the connection events when connecting, set up the listener BEFORE connecting...
    ESenseManager.connectionEvents.listen((event) {
      print('CONNECTION event: $event');

      // when we're connected to the eSense device, we can start listening to events from it
      if (event.type == ConnectionType.connected) listenToESenseEvents();

      switch (event.type) {
        case ConnectionType.connected:
          deviceStatus = IconData(57768, fontFamily: 'MaterialIcons');
          connectedColor = Colors.lightGreen;
          batteryStatus = IconData(57764, fontFamily: 'MaterialIcons');
          batteryColor = Colors.lightGreen;
          break;
        case ConnectionType.unknown:
          deviceStatus = IconData(
            57675,
            fontFamily: 'MaterialIcons',
          );
          connectedColor = Colors.redAccent;
          break;
        case ConnectionType.disconnected:
          deviceStatus = IconData(57769, fontFamily: 'MaterialIcons');
          connectedColor = Colors.redAccent;
          batteryStatus = IconData(57756, fontFamily: 'MaterialIcons');
          batteryColor = Colors.grey;
          break;
        case ConnectionType.device_found:
          deviceStatus = IconData(57770, fontFamily: 'MaterialIcons');
          connectedColor = Colors.grey;
          break;
        case ConnectionType.device_not_found:
          deviceStatus = IconData(57769, fontFamily: 'MaterialIcons');
          connectedColor = Colors.redAccent;
          batteryStatus = IconData(57756, fontFamily: 'MaterialIcons');
          batteryColor = Colors.grey;
          break;
      }
    });

    con = await ESenseManager.connect(eSenseName);

    deviceStatus = con
        ? IconData(57770, fontFamily: 'MaterialIcons')
        : IconData(57675, fontFamily: 'MaterialIcons');
  }

  StreamSubscription subscriptionButton;

  void listenToESenseEvents() async {
    ESenseManager.eSenseEvents.listen((event) {
      //print('ESENSE event: $event');
      switch (event.runtimeType) {
        case BatteryRead:
          if ((event as BatteryRead).voltage < 4.0) {
            batteryColor = Colors.redAccent;
            batteryStatus = IconData(57756, fontFamily: 'MaterialIcons');
          }
          break;
        case ButtonEventChanged:
          break;
        case AccelerometerOffsetRead:
          // TODO
          break;
        case AdvertisementAndConnectionIntervalRead:
          // TODO
          break;
        case SensorConfigRead:
          // TODO
          break;
      }
    });

    getESenseProperties();
  }

  void getESenseProperties() async {
    // get the battery level every 10 secs
    _T1 = Timer.periodic(Duration(seconds: 10),
        (timer) async => await ESenseManager.getBatteryVoltage());
    // wait 2, 3, 4, 5, ... secs before getting the name, offset, etc.
    // it seems like the eSense BTLE interface does NOT like to get called
    // several times in a row -- hence, delays are added in the following calls
  }

  Stream<SensorEvent> events() {
    return ESenseManager.sensorEvents;
  }

  Stream<ESenseEvent> eSenseEvents() {
    return ESenseManager.eSenseEvents;
  }

  bool connnected() {
    return ESenseManager.connected;
  }
}

class Settings {
  bool Leader = true;
}
