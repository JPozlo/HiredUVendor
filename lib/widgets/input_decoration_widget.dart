import 'package:flutter/material.dart';
import 'package:hired_u_vendor/utils/utils.dart';

label(String text) => Text(text);

InputDecoration inputFieldDecoration(String hintText){
  return InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(74, 77, 84, 0.2),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: AppTheme.mainOrangeColor,
      ),
    ),
    hintText: hintText,
    hintStyle: TextStyle(
      fontSize: 14.0,
      color: Color.fromRGBO(105, 108, 121, 0.7),
    ),
  );
}