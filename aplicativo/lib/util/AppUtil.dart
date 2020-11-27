import 'package:app_system_recommender/dao/API.dart';
import 'package:app_system_recommender/model/Genre.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUtil {
  static String convertToDate(String date, {mode = "Y"}) {
    var sp = date.split("-");

    try {
      switch (mode) {
        case 'Y':
          return sp[0];
      }
    } catch (e) {
      return "";
    }

    return "";
  }

  static String genresToList(List<Genre> listGenres) {
    String result = "";

    for (int i = 0; i < listGenres.length; i++) {
      if (i == (listGenres.length - 1)) {
        result += listGenres[i].name;
      } else {
        result += listGenres[i].name + ", ";
      }
    }
    print("O RESULTADO É: " + result);
    return result;
  }

  static dialogMessage(BuildContext context, String title, String message,
      DialogType type) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.BOTTOMSLIDE,
      title: title,
      desc: message,
      btnOkOnPress: () {},
    )
      ..show();
  }

  static String getIdUser() {
    Firebase.initializeApp();
    return FirebaseAuth.instance.currentUser.uid;
  }

  static Future<String> getIP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ip = prefs.getString("ip");

    if(ip == null){
      return null;
    }

    return ip;
  }

  static Future<bool> saveIP(String ip) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("ip", ip);
  }
}
