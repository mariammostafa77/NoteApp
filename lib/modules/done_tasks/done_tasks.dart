import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/todo_cubit.dart';
import '../../shared/cubit/todo_cubit_states.dart';

class DoneScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener:(context, state){} ,
      builder:(context, state){
        var tasks=AppCubit.getInstance(context).doneTasks;
        return ConditionalBuilder(
          condition: tasks.isNotEmpty,
          builder: (context) => ListView.separated(
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
              itemCount: tasks.length),
          fallback: (context){
            return const Center(child: Text('No Done Tasks yet'));
          },
        );
      } ,

    );
  }

}