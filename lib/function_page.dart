import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:app_final/base_setting.dart';


class CalendarPage extends StatefulWidget{
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final List<String> weekdayText = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
  int year = DateTime.now().year;
  int month = DateTime.now().month;
  List<String> data = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];


  List<List<int>> generateCalendarDays(){
    List<List<int>> days = [];
    DateTime firstDay = DateTime(year, month, 1);
    int totalDaysInMonth = DateTime(year, month+1, 0).day;

    int currentDay = 1;
    int weekdayOfFirstDay = firstDay.weekday;
    int row = 1;

    days.add([-7, -6, -5, -4, -3, -2, -1]); // 放入星期

    while(currentDay <= totalDaysInMonth){
      if(days.length <= row)
        days.add([]);
      
      if(currentDay == 1)
        for(int i=0; i<weekdayOfFirstDay-1; i++)  // 補齊1號不在周一的空缺
          days[row].add(0);

      days[row].add(currentDay);

      if( (weekdayOfFirstDay + currentDay - 1) % 7 == 0)
        row++;
      
      currentDay++;
    }

    if(days.length != row)  // 如果days.length = row 最後一列已填滿
      while(days[row].length != 7)  // 補齊最後一列的空缺
        days[row].add(0);
    return days;
  }

  Future<void> showYearMonthPicker(BuildContext context) async{
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return  AlertDialog(
          backgroundColor: BACKGROUNT_COLOR,
          contentPadding: EdgeInsets.all(8.0),
          title: Text(
            '$year年$month月',
            style: TextStyle(fontSize: 24, color: TEXT_COLOR),
          ),
          content: Container(
            // height: 1200,
            width: 400,
            child: Column(
              children: [
                Row(  // 年分
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton( // 減一年
                      onPressed: () {
                        year--;
                        Navigator.of(context).pop();
                        showYearMonthPicker(context);
                      }, 
                      icon: Icon(Icons.remove),
                      color: TEXT_COLOR,
                    ),

                    Text(
                      '$year年',
                      style: TextStyle(fontSize: 24, color: TEXT_COLOR),
                    ),

                    IconButton( // 加一年
                      onPressed: () {
                        year++;
                        Navigator.of(context).pop();
                        showYearMonthPicker(context);
                      }, 
                      icon: Icon(Icons.add),
                      color: TEXT_COLOR,
                    ),
                  ],
                ),

                Divider(),  // 分隔線
                
                Container(
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index){
                      int m = index + 1;
                      return Container(
                        child: ElevatedButton(
                          onPressed: () {
                            month = m;
                            print('選擇了 $year 年 $m 月');
                            setState(() {});  // 更新頁面狀態
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            '$m 月',
                            style: TextStyle(fontSize: 20, color: TEXT_COLOR),
                          ),
                          style: ElevatedButton.styleFrom(primary: BACKGROUNT_COLOR),
                        ),
                      );
                    },
                    itemCount: 12,
                  ),
                ),
                
              ],
            ),
          )
           
        );
        
      },
    );
  }

  @override
  Widget build(BuildContext context){
    final double maxWidth = MediaQuery.of(context).size.width;
    List<List<int>> calendarDays = generateCalendarDays();

    return Scaffold(
      backgroundColor: BACKGROUNT_COLOR,
      appBar: AppBar(
        title: Text(
          '日曆',
          style: TextStyle(fontSize: 20, color: TEXT_COLOR),
        ),
        backgroundColor: BACKGROUNT_COLOR,
        centerTitle: true,
        iconTheme: IconThemeData(color: TEXT_COLOR),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){},
          ),
        ],
      ),
      body: 
         Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(  // 選擇年月按鈕
              height: 50,
              width: maxWidth,
              color: Color.fromARGB(255, 252, 179, 68),
              child: ElevatedButton(
                onPressed: () {
                // 顯示選擇年份和月份的對話框
                  showYearMonthPicker(context);
                },
                child: Text(
                  '$year年$month月',
                  style: TextStyle(fontSize: 20, color: TEXT_COLOR),
                ),
                style: ElevatedButton.styleFrom(primary: Color.fromARGB(255, 252, 179, 68)),
              ),
            ),

            GridView.builder(  // 月曆
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7, // 7個一行
                mainAxisExtent: 48, // 每隔高度
              ),
              itemBuilder: (context, index){
                int? day = calendarDays[index ~/ 7][index % 7];
                return Container(
                  height: 40,
                  width: 60,
                  child: Center(
                    child: day > 0
                      ? Text( // 日期
                        '$day',
                        style: TextStyle(fontSize: 16, color: TEXT_COLOR),
                      )
                      : day < 0
                        ? Text( // 星期
                          weekdayText[day+7],
                          style: TextStyle(fontSize: 16, color: TEXT_COLOR),
                        )
                        : Text(""),
                  ),
                );
              },
              itemCount: calendarDays.length * 7,
            ),

            Divider(),  // 分格線

            Container(  // 金流結果
              height: 50,
              width: maxWidth * 0.95,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Text(
                      '收入：\$123',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ),
                  SizedBox(
                    child: Text(
                      '支出：\$123',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ),
                  SizedBox(
                    child: Text(
                      '結餘：\$123',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            Divider(), // 分格線
          
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
                                height: 40,
                                child: Center(
                                  child: Text(
                                    data[i],
                                    style: TextStyle(fontSize: 20, color: BACKGROUNT_COLOR),
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
      
    );
  }
}