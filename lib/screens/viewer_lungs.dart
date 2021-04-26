import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class UnityViewingWrapperL extends StatefulWidget {
  UnityViewingStateL createState() => UnityViewingStateL();
}

class UnityViewingStateL extends State<UnityViewingWrapperL> {
  UnityWidgetController _unityWidgetController;
  double _sliderValue = 0.0;
  Socket clientSocket = null;

  get onUnityMessage => null;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Student")),
        body: Card(
            margin: const EdgeInsets.all(8),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Stack(
              children: [
                // connectArea(),
                // Padding(
                //   padding: const EdgeInsets.only(top: 2000),
                // ),
                UnityWidget(
                  onUnityCreated: _onUnityCreated,
                  onUnityMessage: onUnityMessage,
                ),
              ],
            )));
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
