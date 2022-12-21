
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:note_app/shared/cubit/todo_cubit.dart';

Widget defaultTextFormField({
  required TextEditingController textEditingController,
  required TextInputType textInputType,
  bool isObscureText=false,
  void Function(String)? onSubmit,
  void Function(String)? onChange,
  void Function()? onTap,
  required String? Function(String?)?  validate,
  required String labelText,
  required Icon prefixIcon,
  IconButton? suffixIcon,
  bool isReadOnly=false,
})=>TextFormField(
  keyboardType: textInputType,
  obscureText: isObscureText,
  controller: textEditingController,
  decoration: InputDecoration(
    border: const OutlineInputBorder(),
    labelText: labelText,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
  ),
  onTap: onTap,
  readOnly: isReadOnly,
  onChanged: onChange,
  onFieldSubmitted: onSubmit,
  validator: validate,
);

Widget todoItem({
  required Map model,
  context,
})=>Dismissible(
  key: Key(model['id'].toString()),
  onDismissed:(direction){
    AppCubit.getInstance(context).deleteFromDatabase(id: model['id']);
  },
  child:   Padding(

    padding: const EdgeInsets.all(10.0),

    child:   Row(

      children: [

        CircleAvatar(

          radius: 35.0,

          backgroundColor: Colors.teal,

          child: Text(

            model['time'],

            textAlign: TextAlign.center,

            style:const TextStyle(

              color: Colors.white,

              fontSize: 14.0,

            ),

          ),

        ),

        const SizedBox(width: 10.0,),

        Expanded(

          child: Column(

            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(

                model['title'],

                style: const TextStyle(

                  fontSize: 20.0,

                  fontWeight: FontWeight.w400,

                  ),

              ),

              const SizedBox(height: 5.0,),

              Text(

                model['date'],

                style: const TextStyle(

                    fontSize: 14.0,

                    color: Colors.grey,

                    ),

              ),

            ],

          ),

        ),

        IconButton(

          onPressed: (){

            AppCubit.getInstance(context).updateDatabase(status: 'done', id: model['id']);

          },

          icon: const Icon(Icons.check_box),

          color: Colors.green,

        ),

        IconButton(

          onPressed: (){

            AppCubit.getInstance(context).updateDatabase(status: 'archive', id: model['id']);

          },

          icon: const Icon(Icons.archive),

          color: Colors.black45,

        ),

      ],

    ),

  ),
);

void showToast(String message)=>Fluttertoast.showToast(msg: message);