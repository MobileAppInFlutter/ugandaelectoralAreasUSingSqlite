import 'package:flutter/material.dart';
import 'package:working_with_sqlt/ui/data_screen.dart';
class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  AppBar(
        title:  Text("Kampeni"), 
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
      ),
      body:  DbData(),
    );
  }


}