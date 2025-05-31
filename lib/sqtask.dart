import 'package:sqltodoflutter/sqaddtask.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqltodoflutter/database.dart';

class Task {
  int? id;
  String title;
  String category;
  String dueDate;
  String timeClock;
  bool isCompleted;

  Task({
    this.id,
    required this.title,
    required this.category,
    required this.dueDate,
    required this.timeClock,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'dueDate': dueDate,
      'timeClock': timeClock,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      category: map['category'],
      dueDate: map['dueDate'],
      timeClock: map['timeClock'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
class SqTask extends StatefulWidget {
  const SqTask({super.key});

  @override
  State<SqTask> createState() => _SqTaskState();
}

class _SqTaskState extends State<SqTask> {
  List<Task> tasks = [];
  int indexItem = 0;
  var selectDate = DateTime.now();

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
    switch (indexItem) {
      case 1:
        return tasks.where((task) => !task.isCompleted).toList();

      case 2:
        return tasks.where((task) => task.isCompleted).toList();

      default:
        return tasks;
    }
  }

  String appBarTitle() {
    switch (indexItem) {
      case 1:
        return 'Pending';

      case 2:
        return 'Completed';

      default:
        return 'Tasks';
    }
  }

  IconButton taskButtonTor() {
    switch (indexItem) {
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
              MaterialPageRoute(builder: (context) => SqAddTask()),
            );
            if (newTask != null) {
              await _addTask(
                Task(
                  title: newTask['title'],
                  category: newTask['category'],
                  dueDate: newTask['dueDate'],
                  timeClock: newTask['timeClock'],
                ),
              );
            }
          },
        );
    }
  }

  Color addColor() {
    switch (indexItem) {
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
    List<Task> emptyTasks = emTpyTasks();
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
                  '    ${DateFormat('MMMM, d').format(selectDate)}',
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
          (emptyTasks.isEmpty)
              ? Center(
                child: Text(
                  'No task available',
                  style: TextStyle(fontSize: 25, color: Colors.black),
                ),
              )
              : ListView.builder(
                itemCount: emptyTasks.length,
                itemBuilder: (context, index) {
                  final task = emptyTasks[index];
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
                      '${task.category} - ${task.dueDate} - ${task.timeClock}',
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
                                  return Column(
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
                      indexItem = 0;
                    });
                  },
                  style: TextButton.styleFrom(
                    foregroundColor:
                    indexItem == 0 ? Colors.white : Colors.black,
                    backgroundColor:
                    indexItem == 0 ? Colors.black : Colors.white,
                    padding: EdgeInsets.fromLTRB(40, 8, 40, 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ), // Rounded corners
                    ),
                  ),
                  child: Text('All'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      indexItem = 1;
                    });
                  },
                  style: TextButton.styleFrom(
                    foregroundColor:
                    indexItem == 1 ? Colors.white : Colors.black,
                    backgroundColor:
                    indexItem== 1 ? Colors.black : Colors.white,
                    padding: EdgeInsets.fromLTRB(25, 8, 25, 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ), // Rounded corners
                    ),
                  ),
                  child: Text('Pending'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      indexItem = 2;
                    });
                  },
                  style: TextButton.styleFrom(
                    foregroundColor:
                    indexItem== 2 ? Colors.white : Colors.black,
                    backgroundColor:
                    indexItem == 2 ? Colors.black : Colors.white,
                    padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ), // Rounded corners
                    ),
                  ),
                  child: Text('Completed'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
