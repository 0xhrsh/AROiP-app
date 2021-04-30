import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_ip/get_ip.dart';
import 'package:shared_preferences/shared_preferences.dart';

SocketClientState pageState;
int msgs = 0;
var ftime;
var ltime;
var times = 100000;
var ltc = 0;

class SocketClient extends StatefulWidget {
  @override
  SocketClientState createState() {
    pageState = SocketClientState();
    return pageState;
  }
}

class SocketClientState extends State<SocketClient> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String localIP = "";
  int port = 9000;
  List<MessageItem> items = List<MessageItem>();

  TextEditingController ipCon = TextEditingController();
  TextEditingController msgCon = TextEditingController();

  Socket clientSocket;

  @override
  void initState() {
    super.initState();
    getIP();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadServerIP();
    });
  }

  @override
  void dispose() {
    disconnectFromServer();
    super.dispose();
  }

  void getIP() async {
    var ip = await GetIp.ipAddress;
    setState(() {
      localIP = ip;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(title: Text("Socket Client")),
        body: Column(
          children: <Widget>[
            ipInfoArea(),
            connectArea(),
            messageListArea(),
            submitArea(),
          ],
        ));
  }

  Widget ipInfoArea() {
    return Card(
      child: ListTile(
        dense: true,
        leading: Text("IP"),
        title: Text(localIP),
      ),
    );
  }

  Widget connectArea() {
    return Card(
      child: ListTile(
        dense: true,
        leading: Text("Server IP"),
        title: TextField(
          controller: ipCon,
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              isDense: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(color: Colors.grey[300]),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(color: Colors.grey[400]),
              ),
              filled: true,
              fillColor: Colors.grey[50]),
        ),
        trailing: RaisedButton(
          child: Text((clientSocket != null) ? "Disconnect" : "Connect"),
          onPressed:
              (clientSocket != null) ? disconnectFromServer : connectToServer,
        ),
      ),
    );
  }

  Widget messageListArea() {
    return Expanded(
      child: ListView.builder(
          reverse: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            MessageItem item = items[index];
            return Container(
              alignment: (item.owner == localIP)
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: (item.owner == localIP)
                        ? Colors.blue[100]
                        : Colors.grey[200]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      (item.owner == localIP) ? "Client" : "Server",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      item.content,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget submitArea() {
    return Card(
      child: ListTile(
        title: TextField(
          controller: msgCon,
        ),
        trailing: IconButton(
          icon: Icon(Icons.send),
          color: Colors.blue,
          disabledColor: Colors.grey,
          onPressed: (clientSocket != null) ? submitMessage : null,
        ),
      ),
    );
  }

  void connectToServer() async {
    print("Destination Address: ${ipCon.text}");
    _storeServerIP();

    Socket.connect(ipCon.text, port, timeout: Duration(seconds: 5))
        .then((socket) {
      setState(() {
        clientSocket = socket;
      });

      showSnackBarWithKey(
          "Connected to ${socket.remoteAddress.address}:${socket.remotePort}");
      socket.listen(
        (onData) {
          // print(String.fromCharCodes(onData).trim().split("\n"));

          setState(() {
            // var rtime = DateTime.now();
            // var stime = DateTime.now();
            // var stime = DateTime.parse(
            // String.fromCharCodes(onData).trim().split("\n").first);

            // items.insert(
            //     0,
            //     MessageItem(clientSocket.remoteAddress.address,
            //         String.fromCharCodes(onData).trim()));

            ltime = DateTime.now();

            var pkgs = String.fromCharCodes(onData).trim().split("\n");
            // msgs += pkgs.length;

            // for (var i = 0; i < pkgs.length; i++) {}
            try {
              ltc += ltime
                  .difference(DateTime.parse(pkgs[pkgs.length - 1]))
                  .inMilliseconds;
              msgs++;
            } on FormatException {
              // msgs--;
            }

            if (msgs > 0) {
              items.insert(
                  0,
                  MessageItem(clientSocket.remoteAddress.address,
                      (ltc / msgs).toString()));

              print(msgs);
            }

            // rtime.difference(stime).inMilliseconds.toString()
          });
        },
        onDone: onDone,
        onError: onError,
      );
    }).catchError((e) {
      showSnackBarWithKey(e.toString());
    });
  }

  void onDone() {
    showSnackBarWithKey("Connection has terminated.");
    disconnectFromServer();
  }

  void onError(e) {
    print("onError: $e");
    showSnackBarWithKey(e.toString());
    disconnectFromServer();
  }

  void disconnectFromServer() {
    print("disconnectFromServer");

    clientSocket.close();
    setState(() {
      clientSocket = null;
    });
  }

  void sendMessage(String message) {
    clientSocket.write(DateTime.now().toString() + "\n");
    // .millisecondsSinceEpoch
    // clientSocket.write(
    //     "    {\"objs\":[{\"id\":1,\"x\":1,\"y\":1,\"z\":1,\"px\":1,\"py\":1,\"pz\":1},{\"id\":1,\"x\":1,\"y\":1,\"z\":1,\"px\":1,\"py\":1,\"pz\":1}]}\n");
  }

  void _storeServerIP() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("serverIP", ipCon.text);
  }

  void _loadServerIP() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      ipCon.text = sp.getString("serverIP");
    });
  }

  void submitMessage() {
    if (msgCon.text.isEmpty) return;
    msgs = 0;
    ltc = 0;
    var stime = DateTime.now();

    for (var i = 0; i < times; i++) {
      // msgCon.text = i.toString();
      // setState(() {
      //   items.insert(0, MessageItem(localIP, msgCon.text));
      // });
      // sleep(Duration(milliseconds: 10));
      sendMessage(msgCon.text);

      msgCon.clear();
    }
    print("All done in..." +
        DateTime.now().difference(stime).inMilliseconds.toString() +
        " ms");
    print("Sending updates after avg: " +
        (DateTime.now().difference(stime).inMilliseconds / (times - 1))
            .toString() +
        " ms");
  }

  showSnackBarWithKey(String message) {
    scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'Done',
          onPressed: () {},
        ),
      ));
  }
}

class MessageItem {
  String owner;
  String content;

  MessageItem(this.owner, this.content);
}
