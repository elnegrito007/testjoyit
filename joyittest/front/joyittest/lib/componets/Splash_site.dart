
import 'dart:js';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Splash_site extends StatefulWidget {

  Splash_site();

  @override
  Splash_siteState createState() => Splash_siteState();

}

class Splash_siteState extends State<Splash_site> {

  Splash_siteState();

  @override
  void initState() {
    new Future.delayed(new Duration(seconds: 4), () async {
      Navigator.pushNamed(this.context, 'dashboard');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: Container(
          color: Colors.white,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FadeInLeft(
                        child:Container(
                          height: 200,
                          width: 200,
                          child: Image.network("data:image/jpeg;base64,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"),
                        )
                    ),
                    FadeInRight(child: Text("Test Joy It",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),),)
                  ],
                )
              ],
            )
        ),
      )
    );
  }

}