
import 'package:mobile_computing_earable/figuren/halberechtsdrehung.dart';
import 'package:mobile_computing_earable/test.dart';
import 'package:flutter/material.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'dart:core';
import 'package:mobile_computing_earable/charts.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flutter/services.dart';
import 'package:esense_flutter/esense.dart';

import 'package:simple_permissions/simple_permissions.dart';
import 'package:csv/csv.dart';

import 'package:just_audio/just_audio.dart';
import 'package:mobile_computing_earable/steplistnew.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

import 'evaluationDialog.dart';



class MyApp extends StatefulWidget {
  EsenseConnector _connector;
  Settings _settings;
  MyApp(EsenseConnector a,Settings b){
    _connector = a;
    _settings = b;
  }
  @override
  _MyAppState createState() => _MyAppState(_connector,_settings);
}



class _MyAppState extends State<MyApp> {
  EsenseConnector connector;
  Settings settings;
  Color leadFollower;
  bool test;

  _MyAppState(EsenseConnector a,Settings b){
    connector = a;
    settings = b;
    test = settings.Leader;

    if(settings.Leader){
      leadFollower = Colors.blueAccent;
    }else{
      leadFollower = Colors.redAccent;
    }
  }



  String _event = '';

  List<int> data_acc_x =[];
  List<int> data_acc_y =[];
  List<int> data_acc_z =[];

  List<int> data_gyr_x =[];
  List<int> data_gyr_y =[];
  List<int> data_gyr_z =[];

  List<int> data_time = [];

  bool gyroX = false;
  bool gyroY = false;
  bool gyroZ = false;

  bool accX = false;
  bool accY = false;
  bool accZ = false;

  final _volumeSubject = BehaviorSubject.seeded(1.0);
  final _speedSubject = BehaviorSubject.seeded(1.0);



  AudioPlayer _player;

  DateTime start;
  DateTime end;

  bool sampling = false;



  IconData _deviceStatus = IconData(57770, fontFamily: 'MaterialIcons');
  IconData _batteryStatus = IconData(57766, fontFamily: 'MaterialIcons', matchTextDirection: true);
  Color _connectedColor = Colors.red;
  Color _batteryColor = Colors.grey;

  Timer T1;
  Timer T2;





  StreamSubscription _buttonSub;
  StreamSubscription _gyroSub;

  void recolor() async{
    setState(() {
      if(settings.Leader){
        leadFollower = Colors.blueAccent;
      }else{
        leadFollower = Colors.redAccent;
      }
    });
  }


  @override
  void initState() {
    super.initState();
    refresh ();
    //_connectToESense();
    getESensePropertiesfromConnector();
    _player = AudioPlayer();
    _player.setAsset("assets/project.mp3");

    bool _buttonListener = true;
    listenToButton();

  }

  void getESensePropertiesfromConnector() async {

    // get every 2 secs
    T1 = Timer.periodic(Duration(seconds: 10),
            (timer) async => refresh());

  }

  void refresh () async {
    if (mounted) {
      setState(() {
        _deviceStatus = connector.deviceStatus;
        _batteryStatus = connector.batteryStatus;
        _connectedColor = connector.connectedColor;
        _batteryColor = connector.batteryColor;
      });
    }
  }

  void listentoGyro() async{

      _gyroSub = connector.events().listen((event) {
        print('SENSOR event: $event');
        setState(() {
          _event = event.toString();
          data_acc_x.add(event.accel[0]);
          data_acc_y.add(event.accel[1]);
          data_acc_z.add(event.accel[2]);

          data_gyr_x.add(event.gyro[0]);
          data_gyr_y.add(event.gyro[1]);
          data_gyr_z.add(event.gyro[2]);
          data_time.add(event.timestamp.difference(start).inMilliseconds);
        });
      });
      setState(() {
        sampling = true;
      });

  }

  void resetGyro(){

    data_gyr_x = [];
    data_gyr_y = [];
    data_gyr_z = [];

    data_acc_x = [];
    data_acc_y = [];
    data_acc_z = [];

    data_time = [];
    bool gyroX = false;
    bool gyroY = false;
    bool gyroZ = false;

    bool accX = false;
    bool accY = false;
    bool accZ = false;


  }

  getCsv() async {

    //create an element rows of type list of list. All the above data set are stored in associate list
//Let associate be a model class with attributes name,gender and age and associateList be a list of associate model class.


    List<List<dynamic>> rows = List<List<dynamic>>();
    for (int i = 0; i < data_acc_y.length;i++) {

//row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = List();
      row.add(data_time[i]);
      row.add(data_acc_x[i]);
      row.add(data_acc_y[i]);
      row.add(data_acc_z[i]);
      row.add(data_gyr_x[i]);
      row.add(data_gyr_y[i]);
      row.add(data_gyr_z[i]);

      rows.add(row);
    }

    await SimplePermissions.requestPermission(Permission. WriteExternalStorage);
    bool checkPermission=await SimplePermissions.checkPermission(Permission.WriteExternalStorage);

    print("Check Permissions was " + checkPermission.toString());
    if(checkPermission) {

//store file in documents folder

      String dir = (await getExternalStorageDirectory()).absolute.path ;
      String file = "$dir";
      Directory my_Dir = Directory(file);
      print(" FILE " + file);
      int counter = await my_Dir.list().length;
      String savepoint = file+"/"+ DateTime.now().toString()+"-L"+ settings.Leader.toString() +".csv";
      print(" savepoint " + savepoint);
      File f = new File(savepoint);

// convert rows to String and write as csv file

      String csv = const ListToCsvConverter().convert(rows);
      f.writeAsString(csv);
    }


  }



  void pauseGyro() async{
    _gyroSub.cancel();
    _player.stop();
    _player.setAsset("assets/project.mp3");

    setState(() {
      sampling = false;
    });
  }




  void listenToButton() async {
    _buttonSub = connector.eSenseEvents().listen((event) {
      print('ESENSE event: $event');
      setState(() {
        switch (event.runtimeType) {
          case BatteryRead:
            break;
          case ButtonEventChanged:
            if ((event as ButtonEventChanged).pressed) {
              if (connector.connnected()) {
                if (!sampling) {
                  run();
                } else {
                  pauseGyro();
                }

              }
            }
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
    });

  }





  void run(){
    sampling = true;

    listentoGyro();
    start = DateTime.now();
    _player.play();
    
    T2 = Timer(Duration(seconds: 11),() {
      print(start);
      end = DateTime.now();
      print(end);
      pauseGyro();
      getCsv();
      _player.setAsset("assets/project.mp3");
      evaluate();
      resetGyro();

    });
    
    
  }

  bool evaluateAccX(){
    print("eval ACC X");
    bool test1 = checkMean(getSecond(data_time, 8500, 9300), data_acc_x, -10000, 0);
    bool test2 = checkMean(getSecond(data_time, 10000, 12000), data_acc_x, -4000, 5000);
    if(test1&&test2){
      return true;
    }
    return false;
  }

  bool evaluateAccY(){
    print("eval ACC Y");
    bool test1 = checkMean(getSecond(data_time, 8500, 9000), data_acc_y, -10000, 0);
    if(test1){
      return true;
    }
    return false;
  }

  bool evaluateAccZ(){
    print("eval ACC Z");
    bool test1 = checkMean(getSecond(data_time, 8500, 9500), data_acc_z, -3000, 2000);
    bool test2 = checkMean(getSecond(data_time, 10000, 12000), data_acc_z, 3000, 10000);
    if(test1&&test2){
      return true;
    }
    return false;
  }

  bool evaluateGyroX(){
    print("eval Gyro X");
    bool test1 = checkMean(getSecond(data_time, 8500, 9500), data_gyr_x, 0, 6000);
    if(test1){
      return true;
    }
    return false;
  }

  bool evaluateGyroZ(){
    print("eval Gyro Z");
    bool test0 = checkMean(getSecond(data_time, 7700, 8300), data_gyr_z, 0, 4000);
    bool test1 = checkMean(getSecond(data_time, 8500, 9500), data_gyr_z, -6000, -1000);
    if(test0&&test1){
      return true;
    }
    return false;
  }




  List<int> getSecond(List<int> a,int borderlow,int borderhigh){

    print("From " + borderlow.toString() + " to " + borderhigh.toString());
    List<int> returnList = [];
    for (int index = 0; index <a.length; index++){
      int element = a.elementAt(index);
      if (element >= borderlow && element <= borderhigh){
        returnList.add(index);
      }
    }
    return returnList;
  }



  bool checkMean(List<int> index, List<int> values,int borderlow,int borderhigh){
    int sum =0;
    index.forEach((element) {
      sum += values.elementAt(element);
    });
    double mean = sum / index.length;

    print("mean: " + mean.toString() + " should be from " + borderlow.toString() + "to " + borderhigh.toString());

    if (mean >= borderlow && mean <= borderhigh){
      return true;
    }
    return false;
  }

  void evaluate(){
    gyroX = evaluateGyroX();
    gyroZ = evaluateGyroZ();
    accX = evaluateAccX();
    accY = evaluateAccY();
    accZ = evaluateAccZ();
    _notify();

  }

  Future<void> _notify() async {

    int count = 0;
    if (gyroX == true){
      count++;
    }
    if (gyroZ == true){
      count++;
    }
    if (accX == true){
      count++;
    }
    if (accY == true){
      count++;
    }
    if (accZ == true){
      count++;
    }


    if (count >= 3){
      return showDialog(
        context: context,
        builder: (BuildContext context) => CustomDialog(
          title: "Erfolgreich: " +count.toString()+ "/5",
          description:
          "Du hast die halbe Rechtdrehung erfolgreich getanzt. Weiter zu den schwierigeren Figuren.",
          buttonText: "Zurück",

        ),
      );
    }else{

      return showDialog(
        context: context,
        builder: (BuildContext context) => CustomDialog(
          title: "Schade: " +count.toString()+ "/5",
          description:
          "Du hast die halbe Rechtdrehung leider nicht perfekt getanzt. Probiers nochmal.",
          buttonText: "Zurück",

        ),
      );

    }



  }

  Future<void> _notifyOld() async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Deine Halbe Rechtdrehung'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('GyroX:'),
                Text(gyroX.toString()),
                Text('GyroZ:'),
                Text(gyroZ.toString()),
                Text('AccX:'),
                Text(accX.toString()),
                Text('AccY:'),
                Text(accY.toString()),
                Text('AccZ:'),
                Text(accZ.toString()),

              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Zurück'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }



  void dispose() {

    _buttonSub.cancel();
    super.dispose();



  }

  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dance App',
        theme: ThemeData(
          primaryColor: Color(0xff01579B),
        ),
      home: Scaffold(
        appBar: AppBar(
          title: Container(
              child: LiteRollingSwitch(
            //initial value
              value: test,
              textOn: 'Leader',
              textOff: 'Follower',
              colorOn: Colors.blueAccent,
              colorOff: Colors.redAccent,
              iconOn: IconData(57441, fontFamily: 'MaterialIcons',),
              iconOff: IconData(57441, fontFamily: 'MaterialIcons',),
              textSize: 14.0,

              onChanged: (bool state) {
                settings.Leader = state;
                recolor();
              },)),

          actions: <Widget>[
            Container(child:Icon(_deviceStatus,color: _connectedColor),
            ),Container(child: Icon(_batteryStatus,color: _batteryColor)),

          ],
        ),
        body: Align(
          alignment: Alignment.topLeft,
          child: ListView(
            children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[


              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(

                  child: new FittedBox(

                    child: Material(

                        color: Colors.white,
                        elevation: 14.0,
                        borderRadius: BorderRadius.circular(10.0),
                        shadowColor: Color(0x802196F3),
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Container(child: Text("Halbe Rechtsdrehung",
                                  style: TextStyle(color: leadFollower, fontSize: 40.0,fontWeight: FontWeight.bold,height: 2),)),

                              ),
                            ),

                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Container(child: Text("Grundlagen \u00B7 Langsamer Walzer ",
                                  style: TextStyle(color: Colors.black54, fontSize: 40.0,fontWeight: FontWeight.bold,height: 2),)),

                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0,right: 16.0),
                                child: Container(
                                    child: Text("Die Halbe Rechtdrehung gehört zu den Grundlagen \ndes Langsamen Walzers. \nSie ist ein absolutes Muss für jeden Tänzer.",
                                  style: TextStyle(color: Colors.black54, fontSize: 28.0,height: 1,fontWeight: FontWeight.normal),textAlign: TextAlign.left)),

                              ),
                            ),
                            Image(
                              width: 300,
                              height: 300,
                              alignment: Alignment.center,
                              image: AssetImage(
                                  'graphics/halbe_rechtsdrehung.png'),
                            )



                          ],)


                    ),

                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(

                  child: new FittedBox(

                    child: Material(

                        color: Colors.white,
                        elevation: 14.0,
                        borderRadius: BorderRadius.circular(10.0),
                        shadowColor: Color(0x802196F3),
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0,right: 16.0),
                                child: Container(child: Text("Tanze jetzt deine Halbe Rechtsdrehung",
                                  style: TextStyle(color: Colors.black54, fontSize: 40.0,fontWeight: FontWeight.bold,height: 2),)),

                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0,bottom: 20.0,right: 16.0),
                                child: Container(child: Text("Beim Klicken auf den blauen Play Button wird \n"
                                    "Musik abgespielt, diese beginnt mit 4 Takten Vorlauf.\nBeginn auf die 3 mit einem Vorschritt.",
                                    style: TextStyle(color: Colors.black54, fontSize: 28.0,height: 1,fontWeight: FontWeight.normal),textAlign: TextAlign.left)),

                              ),
                            ),




                          ],)


                    ),

                  ),
                ),
              ),

            ],
          )]),



        ),
        floatingActionButton: new FloatingActionButton(
          // a floating button that starts/stops listening to sensor events.
          // is disabled until we're connected to the device.
          /*onPressed: (!ESenseManager.connected)
              ? null
              : (!_sampling)
                  ? _startListenToSensorEvents
                  : _pauseListenToSensorEvents,*/

          backgroundColor: leadFollower,
          tooltip: 'Listen to eSense sensors',
          child: (!sampling) ? Icon(Icons.play_arrow) : Icon(Icons.pause),
        ),
      ),
    );
  }
}






