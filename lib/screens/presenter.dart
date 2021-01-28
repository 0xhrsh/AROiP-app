import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'dart:math';

class UnityPresentingWrapper extends StatefulWidget {
  UnityPresentingState createState() => UnityPresentingState();
}

class UnityPresentingState extends State<UnityPresentingWrapper> {
  UnityWidgetController _unityWidgetController;
  double _sliderValue = 0;
  double os = 0.1;
  int t;
  Stopwatch stopwatch = new Stopwatch()..start();

  get onUnityMessage => null;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AROiP'),
        ),
        body: Card(
          margin: const EdgeInsets.all(8),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack(
            children: <Widget>[
              // UnityWidget(
              //   onUnityCreated: _onUnityCreated,
              //   isARScene: true,
              // ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('cube')
                      .doc('8nnDZgRWjvnpOG8TiSkg')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return new Text("0");
                    }
                    var userDocument = snapshot.data;
                    // setRotationSpeed(userDocument["speed"].toString());
                    if (os != userDocument["speed"]) {
                      os = userDocument["speed"];

                      int n = userDocument["n"];
                      int tl = userDocument["tl"];
                      t = stopwatch.elapsedMilliseconds;
                      // print('time counted: ' + t.toString());
                      // print(userDocument["speed"]);

                      FirebaseFirestore.instance
                          .collection('cube')
                          .doc('8nnDZgRWjvnpOG8TiSkg')
                          .update({
                        'check': userDocument["speed"],
                        'al': (tl + t) / (n + 1),
                        'l': t,
                        'n': n + 1,
                        'tl': tl + t
                      });
                    }

                    return Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Card(
                        elevation: 10,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text("Rotation speed:"),
                            ),
                            Slider(
                              onChanged: (value) {
                                setState(() {
                                  stopwatch.reset();

                                  // print("\n");
                                  // print("Watch resetted");
                                  // print(value);
                                  // print("time: " +
                                  //     stopwatch.elapsedMilliseconds.toString());
                                  // print("\n");

                                  _sliderValue = value;
                                  stopwatch.reset();
                                  os = userDocument["speed"];
                                  Random random = new Random();

                                  FirebaseFirestore.instance
                                      .collection('cube')
                                      .doc('8nnDZgRWjvnpOG8TiSkg')
                                      .update({
                                    'speed': _sliderValue,
                                    'speed2': _sliderValue + random.nextInt(10),
                                    'speed3': _sliderValue + random.nextInt(10),
                                    'speed4': _sliderValue + random.nextInt(10),
                                    'speed5': _sliderValue + random.nextInt(10),
                                    // 'speed6': _sliderValue + random.nextInt(10),
                                    // 'speed7': _sliderValue + random.nextInt(10),
                                    // 'speed8': _sliderValue + random.nextInt(10),
                                    // 'speed9': _sliderValue + random.nextInt(10),
                                    // 'speed10': _sliderValue + random.nextInt(1),
                                    // 'speed11': _sliderValue + random.nextInt(1),
                                    // 'speed12': _sliderValue + random.nextInt(2),
                                    // 'speed13': _sliderValue + random.nextInt(1),
                                    // 'speed14': _sliderValue + random.nextInt(1),
                                    // 'speed15': _sliderValue + random.nextInt(1),
                                    // 'speed16': _sliderValue + random.nextInt(1),
                                    // 'speed17': _sliderValue + random.nextInt(1),
                                    // 'speed18': _sliderValue + random.nextInt(1),
                                    // 'speed19': _sliderValue + random.nextInt(1),
                                    // 'speed20': _sliderValue + random.nextInt(2),
                                    // 'speed21': _sliderValue + random.nextInt(1),
                                    // 'speed22': _sliderValue + random.nextInt(1),
                                    // 'speed23': _sliderValue + random.nextInt(1),
                                    // 'speed24': _sliderValue + random.nextInt(1),
                                    // 'speed25': _sliderValue + random.nextInt(1),
                                    // 'speed26': _sliderValue + random.nextInt(1),
                                    // 'speed27': _sliderValue + random.nextInt(1),
                                    // 'speed28': _sliderValue + random.nextInt(1),
                                    // 'speed29': _sliderValue + random.nextInt(1),
                                    // 'speed30': _sliderValue + random.nextInt(2),
                                    // 'speed31': _sliderValue + random.nextInt(1),
                                    // 'speed32': _sliderValue + random.nextInt(1),
                                    // 'speed33': _sliderValue + random.nextInt(1),
                                    // 'speed34': _sliderValue + random.nextInt(1),
                                    // 'speed35': _sliderValue + random.nextInt(1),
                                    // 'speed36': _sliderValue + random.nextInt(1),
                                    // 'speed37': _sliderValue + random.nextInt(1),
                                    // 'speed38': _sliderValue + random.nextInt(1),
                                    // 'speed39': _sliderValue + random.nextInt(1),
                                    // 'speed40': _sliderValue + random.nextInt(2),
                                    // 'speed41': _sliderValue + random.nextInt(1),
                                    // 'speed42': _sliderValue + random.nextInt(1),
                                    // 'speed43': _sliderValue + random.nextInt(1),
                                    // 'speed44': _sliderValue + random.nextInt(1),
                                    // 'speed45': _sliderValue + random.nextInt(1),
                                    // 'speed46': _sliderValue + random.nextInt(1),
                                    // 'speed47': _sliderValue + random.nextInt(1),
                                    // 'speed48': _sliderValue + random.nextInt(1),
                                    // 'speed49': _sliderValue + random.nextInt(1),
                                    // 'speed50': _sliderValue + random.nextInt(2),
                                    // 'speed51': _sliderValue + random.nextInt(1),
                                    // 'speed52': _sliderValue + random.nextInt(1),
                                    // 'speed53': _sliderValue + random.nextInt(1),
                                    // 'speed54': _sliderValue + random.nextInt(1),
                                    // 'speed55': _sliderValue + random.nextInt(1),
                                    // 'speed56': _sliderValue + random.nextInt(1),
                                    // 'speed57': _sliderValue + random.nextInt(1),
                                    // 'speed58': _sliderValue + random.nextInt(1),
                                    // 'speed59': _sliderValue + random.nextInt(1),
                                    // 'speed60': _sliderValue + random.nextInt(2),
                                    // 'speed61': _sliderValue + random.nextInt(1),
                                    // 'speed62': _sliderValue + random.nextInt(1),
                                    // 'speed63': _sliderValue + random.nextInt(1),
                                    // 'speed64': _sliderValue + random.nextInt(1),
                                    // 'speed65': _sliderValue + random.nextInt(1),
                                    // 'speed66': _sliderValue + random.nextInt(1),
                                    // 'speed67': _sliderValue + random.nextInt(1),
                                    // 'speed68': _sliderValue + random.nextInt(1),
                                    // 'speed69': _sliderValue + random.nextInt(1),
                                    // 'speed70': _sliderValue + random.nextInt(1),
                                  });
                                  // setRotationSpeed(_sliderValue.toString());
                                });
                              },
                              // value: 0,
                              value: userDocument["speed"],
                              min: 0,
                              max: 20,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void onUnityCreated(controller) {
    this._unityWidgetController = controller;
  }

  void setRotationSpeed(String speed) {
    _unityWidgetController.postMessage(
      'Cube',
      'SetRotationSpeed',
      speed,
    );
  }

  void _onUnityCreated(controller) {
    this._unityWidgetController = controller;
  }
}
