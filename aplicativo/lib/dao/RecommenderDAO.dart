import 'dart:async';
import 'dart:convert';
import 'package:app_system_recommender/dao/API.dart';
import 'package:app_system_recommender/model/Character.dart';
import 'package:app_system_recommender/model/Movie.dart';
import 'package:app_system_recommender/model/Recommender.dart';
import 'package:app_system_recommender/util/AppUtil.dart';
import 'package:http/http.dart' as http;

class RecommenderDAO {
  static Future<List<Recommender>> getAll() async {
    final response =
        await http.get(await API.urlRecommender(AppUtil.getIdUser()), headers: await API.header());
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      return data
          .map<Recommender>((json) => Recommender.fromJson(json))
          .toList();
    } else {
      throw Exception('Falha ao carregar');
    }
  }
}
