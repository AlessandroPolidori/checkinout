import 'package:checkinout/Screens/Home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Themes/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: appTheme,
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}