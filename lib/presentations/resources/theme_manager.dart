import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ApplicationTheme {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
        primarySwatch: Colors.lightGreen, //default color
        // primaryColor: isDarkTheme ? Colors.black : Colors.white,
        // backgroundColor: isDarkTheme ? Colors.black : Colors.white,

        dialogBackgroundColor: isDarkTheme ? Colors.grey[700] : Colors.white,
        cardColor: isDarkTheme ? Colors.grey[800] : Colors.white,
        scaffoldBackgroundColor:
            isDarkTheme ? Colors.grey[900] : Colors.grey[100],
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: isDarkTheme ? Colors.white : Colors.black,
              displayColor: isDarkTheme ? Colors.white : Colors.black,
            ),
        inputDecorationTheme: InputDecorationTheme(
            hintStyle:
                TextStyle(color: isDarkTheme ? Colors.grey[400] : Colors.grey),
            iconColor: Colors.lightGreen,
            counterStyle:
                TextStyle(color: isDarkTheme ? Colors.grey[300] : Colors.grey),
            prefixIconColor:
                MaterialStateColor.resolveWith((Set<MaterialState> states) {
              if (states.contains(MaterialState.error)) {
                return Colors.red;
              }
              return Colors.lightGreen;
            }),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Colors.lightGreen, width: 1.5)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red, width: 1.5)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!, width: 1)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                )),
            labelStyle: GoogleFonts.nunito(
                color: isDarkTheme ? Colors.grey[300] : Colors.grey)),
        iconTheme: const IconThemeData(
          color: Colors.lightGreen,
        ),
        listTileTheme: ListTileThemeData(
            iconColor: isDarkTheme ? Colors.white : Colors.black),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                disabledBackgroundColor:
                    isDarkTheme ? Colors.grey[500] : Colors.grey[350],
                disabledForegroundColor:
                    isDarkTheme ? Colors.grey[300] : Colors.white,
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightGreen[400],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)))));
  }
}
