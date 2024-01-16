import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:app_final/function_page.dart';
import 'package:app_final/base_setting.dart';

void main(){
  runApp(myApp());
}


class myApp extends StatelessWidget{
  const myApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.blue),
      home: demo(),
    );
  }
}


class demo extends StatefulWidget {
  const demo({super.key});

  @override
  State<demo> createState() => _demoState();
}


class _demoState extends State<demo> {
  int year = DateTime.now().year;
  int month = DateTime.now().month;
  
  int totalIncome = 9000;
  int totalExpenditure = 11000;
  List<String> data = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];



  Color getTextColor(var s1){
    if(s1=="正常") return Colors.green;
    else if(s1=='過輕') return Colors.amber;
    else return Colors.red;
  }

  String getDayOfWeek(int weekday){
    switch (weekday){
      case 1:
        return '一';
      case 2:
        return '二';
      case 3:
        return '三';
      case 4:
        return '四';
      case 5:
        return '五';
      case 6:
        return '六';
      case 7:
        return '日';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double maxWidth = MediaQuery.of(context).size.width;
    int totalNumbers = DateTime(year, month+1, 0).day;
    String monthString = month.toString().padLeft(2, '0');  // 個位數補0

    return Scaffold(
      backgroundColor: BACKGROUNT_COLOR,
      appBar: AppBar(
        title: Text(
          "記帳",
          style: TextStyle(fontSize: 24, color: TEXT_COLOR),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 45, 44, 58),
        iconTheme: IconThemeData(color: TEXT_COLOR, ),
      ),
      body: Container(
        child: Column(
          children: [
              Container(  // 內文標題
                constraints: BoxConstraints(maxHeight: 100),
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(  // 年分/月份
                      child: Text(
                        '$year/$monthString',
                        style: TextStyle(fontSize: 32, color: TEXT_COLOR),
                        textAlign: TextAlign.center,
                      ),
                    ),
 
                    Container(  // 月曆圖示
                      height: 70.0,
                      width: 70.0,
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage(
                              'images/calendar.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CalendarPage()),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              Container(  // 星期和日期水平滑動清單
                constraints: BoxConstraints(maxHeight: 100),
                height: 100,
                width:  maxWidth * 0.95,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    totalNumbers, 
                    (day) {
                      String dayOfWeek = getDayOfWeek(DateTime(year, month, day+1).weekday);  // 取得星期

                      return GestureDetector(
                        onTap: (){
                          print("Number ${day + 1} tapped");
                        },

                        child: Container(
                          width: 38,
                          height: 70,
                          margin: EdgeInsets.all(8),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '周$dayOfWeek',
                                style: TextStyle(fontSize: 16, color: TEXT_COLOR),
                              ),
                              SizedBox(height: 10,),
                              Text(
                                (day + 1).toString(),
                                style: TextStyle(fontSize: 24, color: TEXT_COLOR),
                              )
                            ],
                          ),
                        ),
                      ); 
                    },
                  ),
                )),
              
              Container(  // 金流結果
                constraints: BoxConstraints(maxHeight: 100),
                height: 100,
                width:  maxWidth * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Text(
                            '本月收入',
                            style: TextStyle(fontSize: 16, color: TEXT_COLOR),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            "\$${totalIncome}",
                            style: TextStyle(fontSize: 24, color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text(
                            '本月支出',
                            style: TextStyle(fontSize: 16, color: TEXT_COLOR),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            "\$${totalExpenditure}",
                            style: TextStyle(fontSize: 24, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text(
                            '本月結餘',
                            style: TextStyle(fontSize: 16, color: TEXT_COLOR),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            "\$${totalIncome - totalExpenditure}",
                            style: TextStyle(fontSize: 24, color: Colors.green),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),

              Container(  // 記帳button
                height: 50,
                width:  maxWidth * 0.9,
                child: ElevatedButton(
                  child: Text(
                    '記一筆',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(primary: Color.fromARGB(255, 206, 141, 45)),
                ),
              ),

              Expanded(  // 項目清單
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        for(int i=0; i<data.length; i++)
                          Column(
                            children: [
                              Container(
                                height: 50,
                                // color: Colors.blue,
                                child: Center(
                                  child: Text(
                                    data[i],
                                    style: TextStyle(fontSize: 20, color: TEXT_COLOR),
                                  )
                                ),
                              ),
                              if(i != data.length-1) Divider(),
                            ],
                          )
                      ],
                    ),
                  ),
                ),
              ),
 
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  '選項清單',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {},
            ),
            Divider(),  // 分隔線
            ListTile(
              title: Text('Item 2'),
              onTap: () {},
            ),
            Divider(),  // 分隔線
            ListTile(
              title: Text('Item 3'),
              onTap: () {},
            ),



          ],
        ),
      ),


    );
  }
}

