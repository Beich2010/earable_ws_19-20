import 'package:flutter/material.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:csv/csv.dart';
import 'dart:async';
import 'dart:io';
import 'package:mobile_computing_earable/charts.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:path_provider/path_provider.dart';


import 'package:flutter/services.dart';
import 'package:esense_flutter/esense.dart';

class TestApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}



class _MyAppState extends State<TestApp> {
  String _deviceName = 'Unknown';
  double _voltage = -1;
  String _deviceStatus = '';
  bool sampling = false;
  String _event = '';
  Widget _chart_x_Acc = Text('Gap_x');
  Widget _chart_y_Acc = Text('Gap_y');
  Widget _chart_z_Acc = Text('Gap_z');
  Widget _chart_x_Gyr = Text('Gap_x');
  Widget _chart_y_Gyr = Text('Gap_y');
  Widget _chart_z_Gyr = Text('Gap_z');

  String _button = 'not pressed';


  List<int> data_acc_x =[];
  List<int> data_acc_y =[];
  List<int> data_acc_z =[];

  List<int> data_gyr_x =[];
  List<int> data_gyr_y =[];
  List<int> data_gyr_z =[];

  List<DateTime> data_time = [];

  // the name of the eSense device to connect to -- change this to your own device.
  String eSenseName = 'eSense-0569';

  @override
  void initState() {
    super.initState();
    _connectToESense();
  }

  Future<void> _connectToESense() async {
    bool con = false;

    // if you want to get the connection events when connecting, set up the listener BEFORE connecting...
    ESenseManager.connectionEvents.listen((event) {
      print('CONNECTION event: $event');

      // when we're connected to the eSense device, we can start listening to events from it
      if (event.type == ConnectionType.connected) _listenToESenseEvents();
      if(mounted == false){
        return;
      }
      setState(() {
        switch (event.type) {
          case ConnectionType.connected:
            _deviceStatus = 'connected';
            break;
          case ConnectionType.unknown:
            _deviceStatus = 'unknown';
            break;
          case ConnectionType.disconnected:
            _deviceStatus = 'disconnected';
            break;
          case ConnectionType.device_found:
            _deviceStatus = 'device_found';
            break;
          case ConnectionType.device_not_found:
            _deviceStatus = 'device_not_found';
            break;
        }
      });
    });

    con = await ESenseManager.connect(eSenseName);

    setState(() {
      _deviceStatus = con ? 'connecting' : 'connection failed';
    });
  }

  void _listenToESenseEvents() async {
    ESenseManager.eSenseEvents.listen((event) {
      print('ESENSE event: $event');

      if(mounted == false){
        return;
      }
      setState(() {
        switch (event.runtimeType) {
          case DeviceNameRead:
            _deviceName = (event as DeviceNameRead).deviceName;
            break;
          case BatteryRead:
            _voltage = (event as BatteryRead).voltage;
            break;
          case ButtonEventChanged:
            if ((event as ButtonEventChanged).pressed) {
              if (ESenseManager.connected) {
                if (!sampling) {
                  _startListenToSensorEvents();
                } else {
                  _pauseListenToSensorEvents();
                  if (data_time.length != 0) {
                    List<TimeSeriesValue> data_x_Acc = createData(
                        data_acc_x, data_time);
                    List<TimeSeriesValue> data_y_Acc = createData(
                        data_acc_y, data_time);
                    List<TimeSeriesValue> data_z_Acc = createData(
                        data_acc_z, data_time);

                    List<TimeSeriesValue> data_x_Gyr = createData(
                        data_acc_x, data_time);
                    List<TimeSeriesValue> data_y_Gyr = createData(
                        data_acc_y, data_time);
                    List<TimeSeriesValue> data_z_Gyr = createData(
                        data_acc_z, data_time);


                    List<charts.Series<TimeSeriesValue,
                        DateTime>> seriesList_x = [
                      new charts.Series<TimeSeriesValue, DateTime>(
                        id: 'X-ACC',
                        colorFn: (_, __) =>
                        charts.MaterialPalette.blue.shadeDefault,
                        domainFn: (TimeSeriesValue value, _) => value.time,
                        measureFn: (TimeSeriesValue value, _) => value.value,
                        data: data_x_Acc,
                      )
                    ];

                    List<charts.Series<TimeSeriesValue,
                        DateTime>> seriesList_y = [
                      new charts.Series<TimeSeriesValue, DateTime>(
                        id: 'Y-ACC',
                        colorFn: (_, __) =>
                        charts.MaterialPalette.blue.shadeDefault,
                        domainFn: (TimeSeriesValue value, _) => value.time,
                        measureFn: (TimeSeriesValue value, _) => value.value,
                        data: data_y_Acc,
                      )
                    ];

                    List<charts.Series<TimeSeriesValue,
                        DateTime>> seriesList_z = [
                      new charts.Series<TimeSeriesValue, DateTime>(
                        id: 'Z-ACC',
                        colorFn: (_, __) =>
                        charts.MaterialPalette.blue.shadeDefault,
                        domainFn: (TimeSeriesValue value, _) => value.time,
                        measureFn: (TimeSeriesValue value, _) => value.value,
                        data: data_z_Acc,
                      )
                    ];


                    List<charts.Series<TimeSeriesValue,
                        DateTime>> seriesList_x_Gyr = [
                      new charts.Series<TimeSeriesValue, DateTime>(
                        id: 'X-Gyr',
                        colorFn: (_, __) =>
                        charts.MaterialPalette.blue.shadeDefault,
                        domainFn: (TimeSeriesValue value, _) => value.time,
                        measureFn: (TimeSeriesValue value, _) => value.value,
                        data: data_x_Gyr,
                      )
                    ];

                    List<charts.Series<TimeSeriesValue,
                        DateTime>> seriesList_y_Gyr = [
                      new charts.Series<TimeSeriesValue, DateTime>(
                        id: 'Y-Gyr',
                        colorFn: (_, __) =>
                        charts.MaterialPalette.blue.shadeDefault,
                        domainFn: (TimeSeriesValue value, _) => value.time,
                        measureFn: (TimeSeriesValue value, _) => value.value,
                        data: data_y_Gyr,
                      )
                    ];

                    List<charts.Series<TimeSeriesValue,
                        DateTime>> seriesList_z_Gyr = [
                      new charts.Series<TimeSeriesValue, DateTime>(
                        id: 'Z-Gyr',
                        colorFn: (_, __) =>
                        charts.MaterialPalette.blue.shadeDefault,
                        domainFn: (TimeSeriesValue value, _) => value.time,
                        measureFn: (TimeSeriesValue value, _) => value.value,
                        data: data_z_Gyr,
                      )
                    ];

                    _chart_x_Acc = new SimpleTimeSeriesChart(seriesList_x);
                    _chart_y_Acc = new SimpleTimeSeriesChart(seriesList_y);
                    _chart_z_Acc = new SimpleTimeSeriesChart(seriesList_z);

                    _chart_x_Gyr = new SimpleTimeSeriesChart(seriesList_x_Gyr);
                    _chart_y_Gyr = new SimpleTimeSeriesChart(seriesList_y_Gyr);
                    _chart_z_Gyr = new SimpleTimeSeriesChart(seriesList_z_Gyr);


                    getCsv();
                    data_acc_x = [];
                    data_acc_y = [];
                    data_acc_z = [];

                    data_gyr_x = [];
                    data_gyr_y = [];
                    data_gyr_z = [];

                    data_time = [];
                  }
                }
              }}
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

    _getESenseProperties();
  }

  void _getESenseProperties() async {
    if(mounted == false){
      return;
    }
    // get the battery level every 10 secs
    Timer.periodic(Duration(seconds: 10),
        (timer) async => await ESenseManager.getBatteryVoltage());

    // wait 2, 3, 4, 5, ... secs before getting the name, offset, etc.
    // it seems like the eSense BTLE interface does NOT like to get called
    // several times in a row -- hence, delays are added in the following calls
    Timer(
        Duration(seconds: 2), () async => await ESenseManager.getDeviceName());
    Timer(Duration(seconds: 3),
        () async => await ESenseManager.getAccelerometerOffset());
    Timer(
        Duration(seconds: 4),
        () async =>
            await ESenseManager.getAdvertisementAndConnectionInterval());
    Timer(Duration(seconds: 5),
        () async => await ESenseManager.getSensorConfig());
  }

  StreamSubscription subscription;

  void _startListenToSensorEvents() async {
    // subscribe to sensor event from the eSense device
    SystemSound.play(SystemSoundType.click);
    subscription = ESenseManager.sensorEvents.listen((event) {
      print('SENSOR event: $event');
      setState(() {
        _event = event.toString();
        data_acc_x.add(event.accel[0]);
        data_acc_y.add(event.accel[1]);
        data_acc_z.add(event.accel[2]);

        data_gyr_x.add(event.gyro[0]);
        data_gyr_y.add(event.gyro[1]);
        data_gyr_z.add(event.gyro[2]);

        data_time.add(event.timestamp);
      });
    });
    setState(() {
      sampling = true;
    });
  }

  List<TimeSeriesValue> createData(List<int> data, List<DateTime> data_time){
    List<TimeSeriesValue> x=[];
    for (int i = 0 ; i< data_time.length; i++){
        x.add(new TimeSeriesValue(data_time[i], data[i]));
    }
    return x;
  }

  void _pauseListenToSensorEvents() async {
    subscription.cancel();


    setState(() {
      sampling = false;

    });
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
    if(checkPermission) {

//store file in documents folder

      String dir = (await getExternalStorageDirectory()).absolute.path ;
      String file = "$dir";
      Directory my_Dir = Directory(file);
      print(" FILE " + file);
      int counter = await my_Dir.list().length;
      String savepoint = file+"/"+ counter.toString() +"filename.csv";
      print(" savepoint " + savepoint);
      File f = new File(savepoint);

// convert rows to String and write as csv file

      String csv = const ListToCsvConverter().convert(rows);
      f.writeAsString(csv);
    }


  }

  void dispose() {
    _pauseListenToSensorEvents();
    ESenseManager.disconnect();
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
          title: const Text('eSense Dance Demo App'),
        ),
        body: Align(
          alignment: Alignment.topLeft,
          child: ListView(
            children: [
              Text('eSense Device Status: \t$_deviceStatus'),
              Text('eSense Device Name: \t$_deviceName'),
              Text('eSense Battery Level: \t$_voltage'),
              Text('eSense Button Event: \t$_button'),
              Text(''),
              Text('$_event'),
              Text('Chart X ACC'),
              SizedBox(
                width: 200.0,
                height: 300.0,
                  child:_chart_x_Acc

                ),
              Text('Chart Y ACC'),
              SizedBox(
                  width: 200.0,
                  height: 300.0,
                  child:_chart_y_Acc

              ),
              Text('Chart Z ACC'),
              SizedBox(
                  width: 200.0,
                  height: 300.0,
                  child:_chart_z_Acc

              ),
              Text('Chart X GYR'),
              SizedBox(
                  width: 200.0,
                  height: 300.0,
                  child:_chart_x_Gyr

              ),
              Text('Chart Y GYR'),
              SizedBox(
                  width: 200.0,
                  height: 300.0,
                  child:_chart_y_Gyr

              ),
              Text('Chart Z GYR'),
              SizedBox(
                  width: 200.0,
                  height: 300.0,
                  child:_chart_z_Gyr

              ),
            ],
          ),



        ),
        floatingActionButton: new FloatingActionButton(
          // a floating button that starts/stops listening to sensor events.
          // is disabled until we're connected to the device.
          onPressed: (!ESenseManager.connected)
              ? null
              : (!sampling)
                  ? _startListenToSensorEvents
                  : _pauseListenToSensorEvents,
          tooltip: 'Listen to eSense sensors',
          child: (!sampling) ? Icon(Icons.play_arrow) : Icon(Icons.pause),
        ),
      ),
    );
  }
}






