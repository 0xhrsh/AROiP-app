import 'package:flutter/foundation.dart';
// import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'tcp/client.dart';
import 'tcp/server.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'WebSocket Demo';
    return MaterialApp(
      title: title,
      home: SocketClient(),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              child: Text("Present"),
              minWidth: double.infinity,
              onPressed: () async {
                Navigator.of(context).push((MaterialPageRoute(
                    builder: (BuildContext context) =>
                        UnityPresentingWrapper())));
              },
            ),
            MaterialButton(
              child: Text("View"),
              minWidth: double.infinity,
              onPressed: () async {
                Navigator.of(context).push((MaterialPageRoute(
                    builder: (BuildContext context) => UnityViewingWrapper())));
              },
            ),
          ],
        ),
      ),
    );
  }
}
