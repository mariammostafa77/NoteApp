import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/modules/archive_tasks/archive_tasks.dart';
import 'package:note_app/modules/done_tasks/done_tasks.dart';
import 'package:note_app/modules/tasks_screen/tasks_screen.dart';

class HomeScreen extends StatefulWidget{

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentTapIndex=0;
  List<Widget> screens=[
    TasksScreen(),
    DoneScreen(),
    ArchiveScreen(),
  ];
  List<String> titles = [
    'Tasks Screen',
    'Done Screen',
    'Archive Screen',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title:Text(titles[currentTapIndex]),
      ),
      body: screens[currentTapIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child:const Icon(Icons.add) ,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTapIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        onTap: (index){
          setState(() {
            currentTapIndex=index;
            print('current index $index');
          });
        } ,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu),label:'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.done),label:'Done'),
          BottomNavigationBarItem(icon: Icon(Icons.archive_outlined),label:'Archive'),
        ],
      ),
    );
  }
}