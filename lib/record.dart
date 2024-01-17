import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:app_final/base_setting.dart';

class AddRecord extends StatefulWidget{
  final int year;
  final int month;
  final int day;

  AddRecord.empty() : year=2024, month=1, day=31;
  AddRecord({Key? key, required this.year, required this.month, required this.day}):super(key: key);

  @override
  State<AddRecord> createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord>{
  TextEditingController moneyController = TextEditingController();  // 金額
  TextEditingController remarkController = TextEditingController(); // 備註
  final List<String> recordOption = ["收入", "支出"];
  final List<String> incomeOptions = ["主動" , "被動", "意外", "其他"];
  final List<String> expenseOptions = ["食","衣","住","行","育","樂"];
  String selectRecord = "收入";    // 選擇清單的值
  String selectsubRecord = "主動"; // 對應收支的值
  bool iszero = true;
  bool tooLength = false;
  late int year;
  late int month;
  late int day;

  @override
  void initState(){
    // 初始化
    super.initState();
    moneyController.text = '0';  // 預設輸入框為0
    year = widget.year;   // 放入年
    month = widget.month; // 放入月
    day = widget.day;     // 放入日
  }

  Future<void> _openDataPickter() async {
    // 月曆
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if(selectedDate != null){
      setState(() { // 更新值
        year = selectedDate.year;
        month = selectedDate.month;
        day = selectedDate.day;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double maxWidth = MediaQuery.of(context).size.width;
    String monthString = month.toString().padLeft(2, '0');  // 個位數補0
    String dayString = day.toString().padLeft(2, '0');  // 個位數補0

    return Consumer<SharedData>(
      builder: (context, data, child){
        return Scaffold(
          backgroundColor: BACKGROUNT_COLOR,
          appBar: AppBar(
            backgroundColor:const Color.fromARGB(255, 45, 44, 58),
            title: Text(
              '新增紀錄',
              style: TextStyle(fontSize: 24, color: TEXT_COLOR),
            ),
            centerTitle: true,
            iconTheme: IconThemeData(color: TEXT_COLOR),
          ),
          body: Container(
            child: Column(
              children: [
                Container(  // 分隔線
                  height: 5,
                  color: Color.fromARGB(255, 224, 126, 95),
                ),

                Container(  // 記入選項和金額
                  height: 100,
                  color: Color.fromARGB(255, 45, 44, 58),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container( // 選擇收支清單
                        padding: EdgeInsets.only(left: 15),
                        child: Center(
                          child: DropdownButton(
                            value: selectRecord,
                            dropdownColor: BACKGROUNT_COLOR,
                            underline: Container(),  // 底線不顯示
                            onChanged: (String? newValue){
                              setState((){
                                selectRecord = newValue!;
                                selectsubRecord = (selectRecord == "收入" ? incomeOptions : expenseOptions)[0];
                              });
                            },
                            items: recordOption
                              .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Column(
                                    children: [
                                      Text(
                                        value,
                                        style: const TextStyle(fontSize: 24, color: TEXT_COLOR),
                                      ),
                                    ],
                                  )
                                );
                              }).toList(),
                          ), 
                        ) ,
                      ),

                      Container( // 對應收支清單
                        height: 100,
                        child: Center(
                          child: DropdownButton(
                            dropdownColor: BACKGROUNT_COLOR,
                            value: selectsubRecord,
                            underline: Container(),  // 底線不顯示
                            onChanged: (String? newValue){
                              setState((){
                                selectsubRecord = newValue!;
                              });
                            },
                            items: (selectRecord == "收入" ? incomeOptions : expenseOptions)
                              .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Column(
                                    children: [
                                      Text(
                                        value,
                                        style: const TextStyle(fontSize: 24, color: TEXT_COLOR),
                                      ),
                                    ],
                                  )
                                );
                              }).toList(),
                          ), 
                        ) ,
                      ),

                      Container(  // 金額輸入
                        padding: EdgeInsets.only(right: 20, top: 14),
                        height: 100,
                        width: 120,
                        child: TextField(
                          textAlign: TextAlign.right,
                          controller: moneyController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 24, color: TEXT_COLOR),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(5),
                          ],
                          decoration: InputDecoration(
                            errorText: tooLength? '最多5位數' : null,
                            border: InputBorder.none,  // 底線不顯示
                            prefix: Text(  // 前贅字
                              "\$",
                              style: const TextStyle(fontSize: 24, color: TEXT_COLOR),
                            ),
                          ),
                          onChanged: (value){
                            if(iszero && value.length == 2){
                              // 清除開頭0
                              value = value[1];
                              if(value != "0")
                                iszero = false;
                              moneyController.text = value;
                            }
                            if(value.isEmpty){
                              // 如果一直按刪除，顯示0
                              moneyController.text = '0';
                              iszero = true;
                            }
                            if(value.length > 5)
                              tooLength = true;
                            else
                              tooLength = false;
                          },
                        ),
                      ),
                    ],


                  ),
                
                ),

                Padding(padding: EdgeInsets.only(top: 20)),  // 分隔線

                Container(  // 日期
                    height: 50,
                    width:  maxWidth * 0.9,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: BACKGROUNT_COLOR),
                      child: Text(
                        '$year/$monthString/$dayString',
                        style: const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      onPressed: () {
                        _openDataPickter();
                      },
                    ),
                  ),

                Padding(padding: EdgeInsets.only(top: 20)),  // 分隔線

                Container(  // 備註
                  constraints: BoxConstraints(maxHeight: 200),
                  padding: EdgeInsets.all(10),
                  width: maxWidth * 0.95,
                  
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:TextField(
                    controller: remarkController,
                    maxLength: 100,
                    maxLines: null,
                    style: const TextStyle(fontSize: 16, color: TEXT_COLOR),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "請輸入備註",
                      hintStyle: const TextStyle(fontSize: 16, color: TEXT_COLOR),
                      counterStyle: const TextStyle(fontSize: 12, color: Colors.white)
                    ),
                  ),
                ),
                
                Padding(padding: EdgeInsets.only(top: 40)),  // 分隔線

                Container(  // 結果提交
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(  // 再記一筆
                          color:const Color.fromARGB(255, 11, 41, 69),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: const Color.fromARGB(255, 11, 41, 69)),
                            onPressed: () {
                              Data newData = Data(
                                recoderOption: selectRecord,
                                recodersubOption: selectsubRecord,
                                remark: remarkController.text,
                                money: int.tryParse(moneyController.text)!,
                                date: DateTime(year, month, day),
                              );
                              data.addData(newData);

                              // 刪除內容
                              remarkController.text = "";  
                              moneyController.text = "0";
                            },
                            child: Text(
                              '再記一筆',
                              style: const TextStyle(fontSize: 28, color: TEXT_COLOR),
                            ),
                          ),
                        ),
                      ),

                      Container(  // 分隔線
                        width: 3,
                        color: Colors.white, 
                      ),

                      Expanded(  // 儲存
                        child: Container(
                          color:const Color.fromARGB(255, 11, 41, 69),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: const Color.fromARGB(255, 11, 41, 69)),
                            onPressed: () {
                              Data newData = Data(
                                recoderOption: selectRecord,
                                recodersubOption: selectsubRecord,
                                remark: remarkController.text,
                                money: int.tryParse(moneyController.text)!,
                                date: DateTime(year, month, day),
                              );
                              data.addData(newData);

                              Navigator.of(context).pop();  // 返回上一頁
                            },
                            child: Text(
                              '儲存',
                              style: const TextStyle(fontSize: 28, color: TEXT_COLOR),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

              ],
            )
          ),
        );
      }
    );

  }
}
