import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 30, 46),
      appBar: AppBar(
        title: Text(
          '日曆',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 31, 30, 46),
        iconTheme: IconThemeData(color: Colors.white, ),
      ),
      body: Center(
        
        child: Text('Your calendar Goes Here', style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );
  }
}