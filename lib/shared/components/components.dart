
import 'package:flutter/material.dart';

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