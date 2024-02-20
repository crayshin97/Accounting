import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

const BACKGROUNT_COLOR = Color.fromARGB(255, 31, 30, 46);
const TEXT_COLOR = Color.fromARGB(255, 255, 255, 255);

class Data{  // 儲存資料結構
  String recoderOption;
  String recodersubOption;
  String remark;
  int money;
  DateTime date;

  Data({
    required this.recoderOption,
    required this.recodersubOption,
    required this.remark,
    required this.money,
    required this.date,
  });

  @override
  String toString(){
    return 'Data { recoderOption: $recoderOption, recodersubOption: $recodersubOption, remark: $remark, money: $money, date: $date }';
  }
}

class SharedData extends ChangeNotifier {
  // 共享資料方式
  List<Data> dataList = [];

  void addData(Data data){
    dataList.add(data);
    notifyListeners();
  }
}

class DateButton extends StatefulWidget {
  final bool isSelect;
  final int day;
  final double fontsize;
  final Function(int) onPressed;

  DateButton({required this.isSelect, required this.day, required this.fontsize, required this.onPressed});

  @override
  _DateButtonState createState() => _DateButtonState();

}

class _DateButtonState extends State<DateButton> {
  // 點擊按鈕變色
  @override
  Widget build(BuildContext context){
    return InkResponse(
      onTap: () {
        setState(() {});  // 更新狀態
        widget.onPressed(widget.day);
      },
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.isSelect ? Color.fromARGB(255, 236, 150, 78):  BACKGROUNT_COLOR,
        ),
        child: Center(
          child: Text(
            '${widget.day}',
            style: TextStyle(fontSize: widget.fontsize, color: widget.isSelect ? Colors.black: TEXT_COLOR),
          ),
        ),
      ),
    );
  }

}

Widget buildDayDataList(SharedData datas, int year, int month, int day, double fontsize, double height, double maxWidth){
  List<Data> dataList = datas.dataList;
  
  List<Data> dataInRange = dataList.where((data) { // 篩選出當天內容
    return data.date == DateTime(year, month, day);
  }).toList();
  
  return Column(
    children: [
      for(Data data in dataInRange)
        Column(
          children: [
            Container(  // 當天清單
              height: height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container( // 類型
                    width: maxWidth * 0.15,
                    child: Text(
                      data.recodersubOption,
                      style: TextStyle(fontSize: fontsize, color: TEXT_COLOR),
                    ),
                  ),
                  
                  Container( // 備註
                    width: maxWidth * 0.55,
                    child: Text(
                      data.remark,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontSize: fontsize, color: TEXT_COLOR),
                    ),
                  ),
                  
                  Container( // 金額
                    width: maxWidth * 0.20,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '\$ ${data.money}',
                        style: TextStyle(fontSize: fontsize, color: data.recoderOption == "收入" ? Colors.blue : Colors.red),
                      ),
                    )
                  ),
                ],
              ),
            ),

            Divider(),  // 分隔線
          ],
        ),
    ],
  );                         
}
