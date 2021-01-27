import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

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
              UnityWidget(
                onUnityCreated: _onUnityCreated,
                isARScene: true,
              ),
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
                    setRotationSpeed(userDocument["speed"].toString());
                    if (os != userDocument["speed"]) {
                      os = userDocument["speed"];

                      int n = userDocument["n"];
                      int tl = userDocument["tl"];
                      t = stopwatch.elapsedMilliseconds;

                      FirebaseFirestore.instance
                          .collection('cube')
                          .doc('8nnDZgRWjvnpOG8TiSkg')
                          .update({
                        'check': userDocument["speed"],
                        'latency': (tl + t) / (n + 1),
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
                                  _sliderValue = value;
                                  stopwatch.reset();
                                  os = userDocument["speed"];
                                  FirebaseFirestore.instance
                                      .collection('cube')
                                      .doc('8nnDZgRWjvnpOG8TiSkg')
                                      .update({'speed': _sliderValue});
                                  setRotationSpeed(_sliderValue.toString());
                                });
                              },
                              // value: 0,
                              value: _sliderValue,
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
