import 'package:aroip/widgets/theme.dart';
import 'package:aroip/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:aroip/screens/presenter.dart';
import 'package:aroip/screens/viewer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AROiP',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Join AR Call'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
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

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appBarMain(context),
//       body: Container(
//         padding: EdgeInsets.symmetric(horizontal: 24),
//         child: Column(
//           children: [
//             Spacer(),
//             Form(
//               child: Column(
//                 children: [
//                   TextFormField(
//                     style: simpleTextStyle(),
//                     decoration: textFieldInputDecoration("Name"),
//                   ),
//                   TextFormField(
//                     style: simpleTextStyle(),
//                     decoration: textFieldInputDecoration("Conference ID"),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 16,
//             ),
//             SizedBox(
//               height: 16,
//             ),
//             GestureDetector(
//               onTap: () {
//                 //TODO
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(vertical: 16),
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(30),
//                     gradient: LinearGradient(
//                       colors: [
//                         const Color(0xff007EF4),
//                         const Color(0xff2A75BC)
//                       ],
//                     )),
//                 width: MediaQuery.of(context).size.width,
//                 child: Text(
//                   "Join In",
//                   style: biggerTextStyle(),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 100,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
