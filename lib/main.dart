import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:app_final/calendar.dart';
import 'package:app_final/record.dart';
import 'package:app_final/base_setting.dart';

void main(){
  runApp(
    ChangeNotifierProvider(
      create: (context) => SharedData(),
      child: myApp(),
    ),
  );
}


class myApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: demo(),
    );
  }
}


class demo extends StatefulWidget {
  @override
  State<demo> createState() => _demoState();
}


class _demoState extends State<demo> {
  int year = DateTime.now().year;
  int month = DateTime.now().month;
  int day = DateTime.now().day;

  int getDayIncome(SharedData datas){
    List<Data> dataList = datas.dataList;
    int total = 0;

    List<Data> dataInRange = dataList.where((data)  {
      return data.date.year == year && data.date.month == month && data.recoderOption == "收入";
    }).toList();

    dataInRange.forEach((element) {
      total += element.money;
    });
    return total;
  }
  int getDayExpense(SharedData datas){
    List<Data> dataList = datas.dataList;
    int total = 0;

    List<Data> dataInRange = dataList.where((data)  {
      return data.date.year == year && data.date.month == month && data.recoderOption == "支出";
    }).toList();

    dataInRange.forEach((element) {
      total += element.money;
    });
    return total;
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

    return Consumer<SharedData>(
      builder: (context, data, child){
        int income = getDayIncome(data);
        int expense = getDayExpense(data);

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
                        (d) {
                          String dayOfWeek = getDayOfWeek(DateTime(year, month, d+1).weekday);  // 取得星期
                          
                          return GestureDetector(
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

                                  DateButton( // 放入日期按鈕
                                    isSelect: day == d+1,
                                    day: d+1,
                                    fontsize: 24,
                                    onPressed: (d) {
                                      setState(() {
                                        day = d;
                                      });
                                    },
                                  ),
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
                        Container( // 收入
                          child: Column(
                            children: [
                              Text(
                                '本月收入',
                                style: TextStyle(fontSize: 16, color: TEXT_COLOR),
                              ),
                              SizedBox(height: 10,),
                              Text(
                                "\$${income}",
                                style: TextStyle(fontSize: 24, color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                        
                        Container(  // 支出
                          child: Column(
                            children: [
                              Text(
                                '本月支出',
                                style: TextStyle(fontSize: 16, color: TEXT_COLOR),
                              ),
                              SizedBox(height: 10,),
                              Text(
                                "\$${expense}",
                                style: TextStyle(fontSize: 24, color: Colors.red),
                              ),
                            ],
                          ),
                        ),

                        Container(  // 結餘
                          child: Column(
                            children: [
                              Text(
                                '本月結餘',
                                style: TextStyle(fontSize: 16, color: TEXT_COLOR),
                              ),
                              SizedBox(height: 10,),
                              Text(
                                "\$ ${income - expense}",
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddRecord(
                              year: year,
                              month: month,
                              day: day,
                            )
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(primary: Color.fromARGB(255, 206, 141, 45)),
                    ),
                  ),

                  Expanded(  // 項目清單
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            buildDayDataList(data, year, month, day, 20, 50, maxWidth)
                          ],
                        ),
                      ),
                    ),
                  ),

              ],
            ),
          ),


        );
      }
    );
  }
}

