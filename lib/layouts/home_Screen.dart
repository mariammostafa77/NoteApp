import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:note_app/shared/cubit/todo_cubit.dart';
import 'package:note_app/shared/cubit/todo_cubit_states.dart';
import 'package:sqflite/sqflite.dart';
import 'package:note_app/modules/archive_tasks/archive_tasks.dart';
import 'package:note_app/modules/done_tasks/done_tasks.dart';
import 'package:note_app/modules/tasks_screen/tasks_screen.dart';
import 'package:note_app/shared/components/components.dart';
import 'package:note_app/shared/components/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertIntoDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.getInstance(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.teal,
              title: Text(cubit.titles[cubit.currentTapIndex]),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentTapIndex],
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetAppear == false) {
                  timeController.text = '';
                  timeController.text = '';
                  dateController.text = '';
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                        elevation: 20.0,
                        (context) => SingleChildScrollView(
                          child: Container(
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
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  defaultTextFormField(
                                      textEditingController: titleController,
                                      textInputType: TextInputType.text,
                                      validate: ((value) {
                                        if (value!.isEmpty) {
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
                                      if (value!.isEmpty) {
                                        return 'Date must not be empty';
                                      }
                                    }),
                                    labelText: 'Date',
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime(2120))
                                          .then((value) {
                                        dateController.text = DateFormat.yMMMd()
                                            .format(value!)
                                            .toString();
                                      });
                                    },
                                    prefixIcon:
                                        const Icon(Icons.date_range_rounded),
                                    isReadOnly: true,
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  defaultTextFormField(
                                    textEditingController: timeController,
                                    textInputType: TextInputType.text,
                                    validate: ((value) {
                                      if (value!.isEmpty) {
                                        return 'Time must not be empty';
                                      }
                                    }),
                                    labelText: 'Time',
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                    isReadOnly: true,
                                    prefixIcon: const Icon(Icons.timer),
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false, icon: const Icon(Icons.edit));
                  });
                  cubit.changeBottomSheetState(
                      isShow: true, icon: const Icon(Icons.add));
                } else {
                  if (formKey.currentState!.validate()) {
                    cubit.addNewTask(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text,
                    );
                  }
                }
              },
              child: cubit.floatingBtnIcon,
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentTapIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.teal,
              onTap: (index) {
                cubit.changeBottomNavState(index);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archive'),
              ],
            ),
          );
        },
      ),
    );
  }
}
