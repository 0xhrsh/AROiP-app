import 'dart:io';

import 'package:aroip/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class UnityViewingWrapper extends StatefulWidget {
  UnityViewingState createState() => UnityViewingState();
}

class UnityViewingState extends State<UnityViewingWrapper> {
  UnityWidgetController _unityWidgetController;
  double _sliderValue = 0.0;
  Socket clientSocket = null;

  get onUnityMessage => null;

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Viewer")),
        body: Card(
            margin: const EdgeInsets.all(8),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Stack(
              children: [
                connectArea(),
                // Padding(
                //   padding: const EdgeInsets.only(top: 2000),
                // ),
                UnityWidget(
                  onUnityCreated: _onUnityCreated,
                  onUnityMessage: onUnityMessage,
                ),
                sliderArea(),
              ],
            )));
  }

  Widget unityArea() {
    return Scaffold(
      // key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Simple Screen'),
      ),
      body: Card(
          margin: const EdgeInsets.all(8),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack(
            children: [
              UnityWidget(
                onUnityCreated: _onUnityCreated,
                onUnityMessage: onUnityMessage,
                // onUnitySceneLoaded: onUnitySceneLoaded,
              ),
              Positioned(
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
                            _sliderValue = value;
                          });
                          setRotationSpeed(value.toString());
                        },
                        value: _sliderValue,
                        min: 0,
                        max: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  // Widget unityArea() {
  //   return Scaffold(
  //       body: Card(
  //     margin: const EdgeInsets.all(8),
  //     clipBehavior: Clip.antiAlias,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(20.0),
  //     ),
  //     child: Stack(
  //       children: <Widget>[
  //         UnityWidget(
  //           onUnityCreated: _onUnityCreated,
  //           isARScene: true,
  //         ),

  //         // setRotationSpeed(_sliderValue.toString());

  //         // )
  //       ],
  //     ),
  //   ));
  //   // );
  // }

  // @override
  Widget sliderArea() {
    return Positioned(
      // top: 350,
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
                  _sliderValue = _sliderValue;
                  setRotationSpeed(_sliderValue.toString());
                });
              },
              value: _sliderValue,
              min: 0,
              max: 20,
            ),
          ],
        ),
      ),
      // )
      // ],
      // ),
    );
    // );
  }

  Widget connectArea() {
    return Positioned(
        top: 1,
        bottom: 20,
        left: 20,
        right: 20,
        child: Card(
          child: ListTile(
            dense: true,
            leading: Text("Connect to Server"),
            trailing: RaisedButton(
              child: Text((clientSocket != null) ? "Disconnect" : "Connect"),
              onPressed: (clientSocket != null)
                  ? disconnectFromServer
                  : connectToServer,
            ),
          ),
        ));
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

  void connectToServer() async {
    String ipServer = "192.168.1.69";
    int port = 5005;
    print("Destination Address: $ipServer");

    Socket.connect(ipServer, port, timeout: Duration(seconds: 10))
        .then((socket) {
      setState(() {
        clientSocket = socket;
        clientSocket.write("viewer");
      });

      socket.listen(
        (onData) {
          print("Data Recieved: " +
              String.fromCharCodes(onData).trim().split("\n")[0]);

          setState(() {
            var pkgs = String.fromCharCodes(onData).trim().split("\n");

            try {
              _sliderValue = double.parse(pkgs[pkgs.length - 1]);
              setRotationSpeed(_sliderValue.toString());
            } on FormatException {
              // do some error handling here
            }
          });
        },
        onDone: onDone,
        onError: onError,
      );
    }).catchError((e) {
      print(e);
      // showSnackBarWithKey(e.toString());
    });
  }

  void onDone() {
    // showSnackBarWithKey("Connection has terminated.");
    disconnectFromServer();
  }

  void onError(e) {
    print("onError: $e");
    // showSnackBarWithKey(e.toString());
    disconnectFromServer();
  }

  void disconnectFromServer() {
    print("disconnectFromServer");
    clientSocket.write("quit\n");
    clientSocket.close();
    setState(() {
      clientSocket = null;
    });
  }
}
