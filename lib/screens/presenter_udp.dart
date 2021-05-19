import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'dart:convert';

class UnityPresentingWrapperUDP extends StatefulWidget {
  UnityPresentingStateUDP createState() => UnityPresentingStateUDP();
}

class UnityPresentingStateUDP extends State<UnityPresentingWrapperUDP> {
  UnityWidgetController _unityWidgetController;
  double _sliderValue = 0.0;
  RawDatagramSocket clientSocket;
  var address;
  int port;

  get onUnityMessage => null;

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Teacher")),
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

                // UnityWidget(
                //   onUnityCreated: _onUnityCreated,
                //   onUnityMessage: onUnityMessage,
                // ),

                sliderArea(),
              ],
            )));
  }

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
              child: Text("Force Applied:"),
            ),
            Slider(
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                  // setRotationSpeed(_sliderValue.toString());
                  sendUpdate(_sliderValue.toString());
                });
              },
              value: _sliderValue,
              min: 0,
              max: 20,
            ),
          ],
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

  void connectToServer() async {
    String ipServer = "192.168.1.69";
    address = new InternetAddress(ipServer);
    port = 5005;
    print("Destination Address: $ipServer");

    RawDatagramSocket.bind("0.0.0.0", 0).then((socket) async {
      setState(() {
        clientSocket = socket;
        clientSocket.send(utf8.encode("init"), address, port);
      });

      socket.listen(
        (onData) {
          if (onData == RawSocketEvent.read) {
            Datagram dg = clientSocket.receive();
            if (dg != null) {
              // print();
              print("Data Recieved: " + utf8.decode(dg.data));

              setState(() {
                try {
                  _sliderValue = double.parse(utf8.decode(dg.data));
                } on FormatException {
                  // do some error handling here
                }
              });
            }
          }
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

  void sendUpdate(String message) {
    clientSocket.send(utf8.encode("presenter " + message), address, port);
  }

  void disconnectFromServer() {
    print("disconnectFromServer");
    clientSocket.send(utf8.encode("quit"), address, port);
    clientSocket.close();
    setState(() {
      clientSocket = null;
    });
  }
}
