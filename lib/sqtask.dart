import 'package:sqltodoflutter/sqaddtask.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqltodoflutter/database.dart';

class Task {
  int? id;
  String title;
  String category;
  String dueDate;
  String timeclock;
  bool isCompleted;

  Task({
    this.id,
    required this.title,
    required this.category,
    required this.dueDate,
    required this.timeclock,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'dueDate': dueDate,
      'timeclock': timeclock,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      category: map['category'],
      dueDate: map['dueDate'],
      timeclock: map['timeclock'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
class Sqtask extends StatefulWidget {
  const Sqtask({super.key});

  @override
  State<Sqtask> createState() => _SqtaskState();
}

class _SqtaskState extends State<Sqtask> {
  List<Task> tasks = [];
  int _IndexItem = 0;
  var selectdate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    tasks = await DatabaseHelper.instance.getTasks();
    setState(() {});
  }

  Future<void> _addTask(Task task) async {
    await DatabaseHelper.instance.insertTask(task);
    _loadTasks();
  }

  Future<void> _updateTask(Task task) async {
    await DatabaseHelper.instance.updateTask(task);
    _loadTasks();
  }

  Future<void> _deleteTask(int id) async {
    await DatabaseHelper.instance.deleteTask(id);
    _loadTasks();
  }

  List<Task> emTpyTasks() {
    switch (_IndexItem) {
      case 1:
        return tasks.where((task) => !task.isCompleted).toList();

      case 2:
        return tasks.where((task) => task.isCompleted).toList();

      default:
        return tasks;
    }
  }

  String appBarTitle() {
    switch (_IndexItem) {
      case 1:
        return 'Pending';

      case 2:
        return 'Completed';

      default:
        return 'Tasks';
    }
  }

  IconButton taskButtonTor() {
    switch (_IndexItem) {
      case 1:
        return IconButton(
          icon: Icon(Icons.timer_outlined),
          color: Colors.white,
          onPressed: () {},
        );
      case 2:
        return IconButton(
          icon: Icon(Icons.check),
          color: Colors.white,
          onPressed: () {},
        );
      default:
        return IconButton(
          icon: Icon(Icons.add),
          color: Colors.white,
          onPressed: () async {
            final newTask = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Sqaddtask()),
            );
            if (newTask != null) {
              await _addTask(
                Task(
                  title: newTask['title'],
                  category: newTask['category'],
                  dueDate: newTask['dueDate'],
                  timeclock: newTask['timeclock'],
                ),
              );
            }
          },
        );
    }
  }

  Color addColor() {
    switch (_IndexItem) {
      case 1:
        return Colors.redAccent;
      case 2:
        return Colors.teal;
      default:
        return Colors.black;
    }
  }


  @override
  Widget build(BuildContext context) {
    List<Task> EmptyTasks = emTpyTasks();
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appBarTitle(),
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text(
                  '    ${DateFormat('MMMM, d').format(selectdate)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ],
            ),
          ],
        ),
        actions: [
          CircleAvatar(
            radius: 25,
            backgroundColor: addColor(),
            child: taskButtonTor(),
          ),
        ],
      ),
      body:
      (EmptyTasks.isEmpty)
          ? Center(
        child: Text(
          'No task availables',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
      )
          : ListView.builder(
        itemCount: EmptyTasks.length,
        itemBuilder: (context, index) {
          final task = EmptyTasks[index];
          TextEditingController demo = TextEditingController(text: task.title);
          return ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                decoration:
                task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: task.isCompleted ? Colors.grey : Colors.black,
              ),
            ),
            subtitle: Text(
              '${task.category} - ${task.dueDate} - ${task.timeclock}',
              style: TextStyle(
                decoration:
                task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: task.isCompleted ? Colors.grey : Colors.black,
              ),
            ),
            leading: Checkbox(
              value: task.isCompleted,
              onChanged: (bool? value) {
                setState(() {
                  task.isCompleted = value!;
                  _updateTask(task);
                });
              },
            ),
            trailing: SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(onPressed: () {
                    showModalBottomSheet(context: context,
                        builder: (context) {
                          return Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Edit Task', style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                SizedBox(height: 100,),
                                SizedBox(
                                  width: 300,
                                  child: TextField(
                                    controller: demo,
                                    decoration: InputDecoration(
                                        hintText:'task',
                                        border: OutlineInputBorder(
                                          borderSide:BorderSide(color: Colors.grey),
                                        )
                                    ),
                                  ),
                                ),
                                SizedBox(height: 100,),
                                ElevatedButton(onPressed: (){
                                  setState(() {
                                    task.title = demo.text;
                                  });
                                  _updateTask(task);
                                  Navigator.pop(context, {});

                                },style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 100),
                                    backgroundColor: Colors.black), child:Text('Save',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),),
                              ],
                            ),
                          );
                        });
                  }, icon: Icon(Icons.edit)),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Expanded(
                            child: AlertDialog(
                              title: Text('Delete'),
                              content: Text('What do you want to delete?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    // _Delete(index);
                                    _deleteTask(task.id!);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'YES',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'NO',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.delete),
                    color: Colors.redAccent,
                  ),
                ],
              ),
            ),
          );
        },
        //scrollDirection: Axis.vertical,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(10, 1, 10, 35),
        child: Card(
          elevation: 15,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _IndexItem = 0;
                    });
                  },
                  child: Text('All'),
                  style: TextButton.styleFrom(
                    foregroundColor:
                    _IndexItem == 0 ? Colors.white : Colors.black,
                    backgroundColor:
                    _IndexItem == 0 ? Colors.black : Colors.white,
                    padding: EdgeInsets.fromLTRB(40, 8, 40, 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ), // Rounded corners
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _IndexItem = 1;
                    });
                  },
                  child: Text('Pending'),
                  style: TextButton.styleFrom(
                    foregroundColor:
                    _IndexItem == 1 ? Colors.white : Colors.black,
                    backgroundColor:
                    _IndexItem == 1 ? Colors.black : Colors.white,
                    padding: EdgeInsets.fromLTRB(25, 8, 25, 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ), // Rounded corners
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _IndexItem = 2;
                    });
                  },
                  child: Text('Completed'),
                  style: TextButton.styleFrom(
                    foregroundColor:
                    _IndexItem == 2 ? Colors.white : Colors.black,
                    backgroundColor:
                    _IndexItem == 2 ? Colors.black : Colors.white,
                    padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ), // Rounded corners
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
