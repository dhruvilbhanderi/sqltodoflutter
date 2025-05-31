import 'package:flutter/material.dart';
class SqAddTask extends StatefulWidget {
  const SqAddTask({super.key});

  @override
  State<SqAddTask> createState() => _SqAddTaskState();
}

class _SqAddTaskState extends State<SqAddTask> {
  String selectValues = 'Personal';
  final TextEditingController _dateController =  TextEditingController();
  final TextEditingController taskController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final List<String> categories = ['Personal', 'Work', 'Health', 'Family', 'Learning'];
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));


    if (picked != null)
    {
      // _dateController.text = _picked.toString().split(" ")[0];
      _dateController.text = '${picked.day}/${picked.month}/${picked.year}';
    }
  }
  Future<void> _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now(),initialEntryMode: TimePickerEntryMode.input);
    if(pickedTime != null)
    {
      _timeController.text = '${pickedTime.hourOfPeriod} : ${pickedTime.minute} ${pickedTime.hour<12?'AM':'PM'}';
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
            SizedBox(
              width: 300,
              child: TextField(
                controller: taskController,
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
            SizedBox(
              width: 300,
              child: DropdownButtonFormField<String>(
                value: selectValues,
                decoration: InputDecoration(
                  hintText: 'Choose a category',
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
            SizedBox(
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
            SizedBox(
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
                'title': taskController.text,
                'category': selectValues,
                'dueDate': _dateController.text,
                'timeClock':_timeController.text,
              });
            },style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 150),
                backgroundColor: Colors.black), child:Text('Save',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),),
          ],
        ),
      ),
    );
  }
}
