import 'package:flutter/material.dart';
class Sqaddtask extends StatefulWidget {
  const Sqaddtask({super.key});

  @override
  State<Sqaddtask> createState() => _SqaddtaskState();
}

class _SqaddtaskState extends State<Sqaddtask> {
  String selectValues = 'Personal';
  final TextEditingController _dateController =  TextEditingController();
  final TextEditingController taskcontroller = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final List<String> categories = ['Personal', 'Work', 'Health', 'Family', 'Learning'];
  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));


    if (_picked != null)
    {
      // _dateController.text = _picked.toString().split(" ")[0];
      _dateController.text = '${_picked.day}/${_picked.month}/${_picked.year}';
    }
  }
  Future<void> _selectTime() async {
    TimeOfDay? pickedtime = await showTimePicker(context: context, initialTime: TimeOfDay.now(),initialEntryMode: TimePickerEntryMode.input);
    if(pickedtime != null)
    {
      _timeController.text = '${pickedtime.hourOfPeriod} : ${pickedtime.minute} ${pickedtime.hour<12?'AM':'PM'}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading:
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 60,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text('cancel',style: TextStyle(fontSize: 18,color: Colors.black),)),
              ],
            ),
            SizedBox(height: 20,),
            Text('Add a task',style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            Container(
              width: 300,
              child: TextField(
                controller: taskcontroller,
                decoration: InputDecoration(
                    hintText: 'Name your task',
                    hintStyle: TextStyle(color: Colors.grey[700]),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    )
                ),
              ),
            ),
            SizedBox(height: 60,),
            Container(
              width: 300,
              child: DropdownButtonFormField<String>(
                value: selectValues,
                decoration: InputDecoration(
                  hintText: 'Choose a categorys',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                items: [
                  DropdownMenuItem(
                      value: categories[0],
                      child: Row(
                        children: [
                          CircleAvatar(radius: 20,backgroundColor: Colors.white,child: Icon(Icons.person,color: Colors.green,shadows: [],)),
                          SizedBox(width: 8),
                          Text(categories[0],style: TextStyle(color: Colors.green),),
                        ],
                      )),
                  DropdownMenuItem(
                      value: categories[1],
                      child: Row(
                        children: [
                          CircleAvatar(radius: 20,backgroundColor: Colors.white,child: Icon(Icons.work,color: Colors.blue,)),
                          SizedBox(width: 8),
                          Text(categories[1],style: TextStyle(color: Colors.blue),),
                        ],
                      )),
                  DropdownMenuItem(
                      value: categories[2],
                      child: Row(
                        children: [
                          CircleAvatar(radius: 20,backgroundColor: Colors.white,child: Icon(Icons.monitor_heart,color: Colors.redAccent,)),
                          SizedBox(width: 8),
                          Text(categories[2],style: TextStyle(color: Colors.redAccent),),
                        ],
                      )),
                  DropdownMenuItem(
                      value: categories[3],
                      child: Row(
                        children: [
                          CircleAvatar(radius: 20,backgroundColor: Colors.white,child: Icon(Icons.home,color: Colors.black,)),
                          SizedBox(width: 8),
                          Text(categories[3],style: TextStyle(color: Colors.black),),
                        ],
                      )),
                  DropdownMenuItem(
                      value: categories[4],
                      child: Row(
                        children: [
                          CircleAvatar(radius: 20,backgroundColor: Colors.white,child: Icon(Icons.school,color: Colors.yellow,)),
                          SizedBox(width: 8),
                          Text(categories[4],style: TextStyle(color: Colors.yellow),),
                        ],
                      )),
                ], onChanged: (values){
                setState(() {
                  selectValues = values!;
                });
              },

              ),
            ),
            SizedBox(height: 60,),
            Container(
              width: 300,
              child: TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  prefixIcon:Icon(Icons.calendar_month),
                  hintText: 'Date',
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                onTap: (){
                  _selectDate();
                },
              ),
            ),
            SizedBox(height: 60,),
            Container(
              width: 300,
              child: TextField(
                controller: _timeController,
                decoration: InputDecoration(
                  prefixIcon:Icon(Icons.access_time_filled),
                  hintText: 'Time',
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                onTap: (){
                  _selectTime();
                },
              ),
            ),
            SizedBox(height: 180,),
            ElevatedButton(onPressed: (){
              Navigator.pop(context, {
                'title': taskcontroller.text,
                'category': selectValues,
                'dueDate': _dateController.text,
                'timeclock':_timeController.text,
              });
            }, child:Text('Save',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 150),
                backgroundColor: Colors.black),),
          ],
        ),
      ),
    );
  }
}
