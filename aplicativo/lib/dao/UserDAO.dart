import 'dart:async';
import 'dart:convert';
import 'package:app_system_recommender/dao/API.dart';
import 'package:app_system_recommender/model/User.dart';
import 'package:firebase_auth/firebase_auth.dart' as Fire;
import 'package:http/http.dart' as http;

class UserDAO {

  static Future<bool> add(User user) async {
    print(user.toJson());
    final response = await http.post(await API.urlRecommender("user"),
        headers: await API.header(),
        body: jsonEncode(user.toJson()));

    if (response.statusCode == 200) {
      print(response.body);
      return true;
    } else {
      return false;
    }
  }
}
