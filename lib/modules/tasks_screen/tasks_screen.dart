import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/shared/components/components.dart';
import 'package:note_app/shared/components/constants.dart';
import 'package:note_app/shared/cubit/todo_cubit.dart';
import 'package:note_app/shared/cubit/todo_cubit_states.dart';

class TasksScreen extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener:(context, state){} ,
      builder:(context, state){
        var tasks=AppCubit.getInstance(context).newTasks;
        return ConditionalBuilder(
            condition:tasks.isNotEmpty,
            builder: (context) {
              return ListView.separated(
                  itemBuilder: (context,index)=> todoItem(
                      model: tasks[index],context: context),
                  separatorBuilder: (context,index)=>Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      color: Colors.grey[300],
                      width: double.infinity,
                      height: 1.0,
                    ),
                  ),
                  itemCount: tasks.length);
            },
          fallback: (context){
              return const Center(child: Text('No Tasks yet, Please Add Some Tasks'));
          },
        );
      } ,

    );
  }
}