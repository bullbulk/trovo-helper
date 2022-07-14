import 'package:flutter/material.dart';
import 'package:trovo_helper/colors.dart' as custom_colors;

var customTheme = (BuildContext context) => ThemeData.dark().copyWith(
      scaffoldBackgroundColor: custom_colors.black,
      backgroundColor: custom_colors.black,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: custom_colors.grayAccent,
        secondary: custom_colors.green,
        background: custom_colors.black,
      ),
      iconTheme: IconTheme.of(context).copyWith(
        color: Colors.white,
      ),
      appBarTheme: AppBarTheme.of(context).copyWith(
        backgroundColor: custom_colors.grayAccent,
      ),
      buttonTheme: ButtonTheme.of(context).copyWith(
        buttonColor: custom_colors.gray,
      ),
      textSelectionTheme: TextSelectionTheme.of(context).copyWith(
        selectionColor: custom_colors.selection,
        cursorColor: Colors.white,
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
        primary: Colors.white,
      )),
    );
