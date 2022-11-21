import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:note_app/modules/archive_tasks/archive_tasks.dart';
import 'package:note_app/modules/done_tasks/done_tasks.dart';
import 'package:note_app/modules/tasks_screen/tasks_screen.dart';
import 'package:note_app/shared/components/components.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentTapIndex = 0;
  List<Widget> screens = [
    TasksScreen(),
    DoneScreen(),
    ArchiveScreen(),
  ];
  List<String> titles = [
    'Tasks Screen',
    'Done Screen',
    'Archive Screen',
  ];
  late Database database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isBottomSheetAppear = false;
  Icon floatingBtnIcon = const Icon(Icons.edit);
  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();


  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(titles[currentTapIndex]),
      ),
      body: screens[currentTapIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBottomSheetAppear == false) {
            setState(() {
              floatingBtnIcon = const Icon(Icons.add);
            });
            timeController.text='';
            timeController.text='';
            dateController.text='';
            scaffoldKey.currentState?.showBottomSheet(
              elevation: 20.0,
              (context) => Container(
                height: 360,
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const Text(
                        'Add New Task',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                      ),),
                      const SizedBox(
                        height: 20.0,
                      ),
                      defaultTextFormField(
                          textEditingController: titleController,
                          textInputType: TextInputType.text,
                          validate: ((value) {
                            if(value!.isEmpty){
                              return 'Title must not be empty';
                            }
                          }),
                          labelText: 'Title',
                          prefixIcon: const Icon(Icons.title)),
                      const SizedBox(
                        height: 10.0,
                      ),
                      defaultTextFormField(
                        textEditingController: dateController,
                        textInputType: TextInputType.text,
                        validate: ((value) {
                          if(value!.isEmpty){
                            return 'Date must not be empty';
                          }
                        }),
                        labelText: 'Date',
                        onTap: (){
                          showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2120))
                              .then((value){
                                dateController.text=DateFormat.yMMMd().format(value!).toString();
                          });
                        },
                        prefixIcon: const Icon(Icons.date_range_rounded),
                        isReadOnly: true,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      defaultTextFormField(
                        textEditingController: timeController,
                        textInputType: TextInputType.text,
                        validate: ((value) {
                          if(value!.isEmpty){
                            return 'Time must not be empty';
                          }
                        }),
                        labelText: 'Time',
                        onTap: () {
                          showTimePicker(
                                  context: context, initialTime: TimeOfDay.now())
                              .then((value) {
                            timeController.text =value!.format(context).toString();
                          });
                        },
                        isReadOnly: true,
                        prefixIcon: const Icon(Icons.timer),
                      ),
                    ],
                  ),
                ),
              ),
            );
            isBottomSheetAppear = true;
          } else {
            if(formKey.currentState!.validate()){
              addNewTask(
                title: titleController.text,
                date: dateController.text,
                time: timeController.text,
              ).then((value){
                Navigator.pop(context);
                setState(() {
                  floatingBtnIcon = const Icon(Icons.edit);
                });
                isBottomSheetAppear = false;
              });

            }
          }
        },
        child: floatingBtnIcon,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTapIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        onTap: (index) {
          setState(() {
            currentTapIndex = index;
            print('current index $index');
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Done'),
          BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined), label: 'Archive'),
        ],
      ),
    );
  }

  void createDatabase() async {
    database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('Database created');
        database
            .execute(
                'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('Table created');
        }).catchError((error) {
          print(' some error ');
        });
      },
      onOpen: (database) {
        print('Database opened');
      },
    );
  }

  Future addNewTask({
    required String title,
    required String date,
    required String time,
  }) async {
    database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks (title, date, time, status) VALUES ("$title", "$date","$time","active")')
          .then((value) {
        print('$value insert successfully');
      }).catchError((error) {
        print(error);
      });
      return null;
    });
  }
}
