import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:note_app/shared/cubit/todo_cubit_states.dart';
import 'package:sqflite/sqflite.dart';
import '../../modules/archive_tasks/archive_tasks.dart';
import '../../modules/done_tasks/done_tasks.dart';
import '../../modules/tasks_screen/tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitState());

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
  bool isBottomSheetAppear = false;
  Icon floatingBtnIcon = const Icon(Icons.edit);
  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archivesTasks=[];
  static AppCubit getInstance(context) => BlocProvider.of(context);

  void changeBottomNavState(int index) {
    currentTapIndex = index;
    emit(AppChangeBottomNavState());
  }

  void createDatabase() {
    openDatabase(
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
        getTasks(database);
        print('Database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  addNewTask({
    required String title,
    required String date,
    required String time,
  }) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks (title, date, time, status) VALUES ("$title", "$date","$time","new")')
          .then((value) {
        print('$value insert successfully');
        emit(AppInsertIntoDatabaseState());
        getTasks(database);
      }).catchError((error) {
        print(error);
      });
      return null;
    });
  }

  void getTasks(database) async {
    newTasks=[];
    archivesTasks=[];
    doneTasks=[];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element){
        if(element['status']=='new'){
          newTasks.add(element);
        }
        else if(element['status']=='done'){
            doneTasks.add(element);
        }
        else{
            archivesTasks.add(element);
          }

      });
      //print(value);
      emit(AppGetFromDatabaseState());
    });
  }

  void updateDatabase({
    required String status,
    required int id,
}){
    database.rawUpdate(
        'UPDATE tasks SET status = ?WHERE id = ?',
        ['$status', id]).then((value){
          getTasks(database);
          emit(AppUpdateDatabaseState());
    });
  }

  void deleteFromDatabase({
    required int id,
  }){
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value){
      getTasks(database);
      emit(AppDeleteFromDatabaseState());
    });
  }


  void changeBottomSheetState({
    required bool isShow,
    required Icon icon
}){
    isBottomSheetAppear=isShow;
    floatingBtnIcon=icon;
    emit(AppChangeBottomSheetState());
  }





}
