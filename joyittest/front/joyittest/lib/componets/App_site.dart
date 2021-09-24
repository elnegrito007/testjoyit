
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Dashboard_site.dart';
import 'Splash_site.dart';

class App extends StatefulWidget {
  App();

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins',
        brightness: Brightness.light,
        primarySwatch: Colors.grey,
        primaryColor: Colors.lightBlue[800],
        accentColor: Color.fromRGBO(35, 30, 70, 255),
        backgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        fontFamily: 'Poppins',
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.grey[50],
        backgroundColor: Color.fromRGBO(35, 30, 70, 255),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Joy It Site',
      initialRoute: 'splash',
      routes: {
        'splash': (BuildContext context) => Splash_site(),
        'dashboard': (BuildContext context) => Dashboard_site(),
      });
  }
}
