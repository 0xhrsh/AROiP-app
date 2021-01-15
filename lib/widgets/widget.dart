import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: new Center(child: new Text("AROiP", textAlign: TextAlign.center)),
    //  Image.asset(
    //   "assets/images/logo.png",
    //   height: 40,
    // ),
    elevation: 0.0,
    centerTitle: false,
  );
}

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 16);
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white54),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)));
}

TextStyle biggerTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 17);
}

Widget getSpeed(BuildContext context) {
  var speed = 0;
  return new StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('cube')
          .doc('8nnDZgRWjvnpOG8TiSkg')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Text("0");
        }
        var userDocument = snapshot.data;
        speed = userDocument["speed"];
        return new Text(userDocument["speed"].toString());
      });
}
