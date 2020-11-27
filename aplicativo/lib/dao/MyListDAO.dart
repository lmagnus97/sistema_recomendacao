import 'dart:async';
import 'dart:convert';
import 'package:app_system_recommender/dao/API.dart';
import 'package:app_system_recommender/model/Movie.dart';
import 'package:app_system_recommender/model/MyList.dart';
import 'package:app_system_recommender/util/AppUtil.dart';
import 'package:http/http.dart' as http;

class MyListDAO {
  static Future<List<MyList>> getAllFromServer() async {
    final response = await http.get(await API.urlRecommender("mylist/" + AppUtil.getIdUser()),
        headers: await API.header());
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      return data.map<MyList>((json) => MyList.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar dados do servidor');
    }
  }

  static Future<List<MyList>> getAll() async {
    List<MyList> list = await MyListDAO.getAllFromServer();

    for (MyList item in list) {
      final response = await http.get(
          API.urlTMDB("3/movie/" + item.tmdbId.toString() + "?language=pt-BR"),
          headers: await API.header());

      if (response.statusCode == 200) {
        print("ENCONTRADO NO TMDB: " + item.tmdbId.toString());
        Movie movie = Movie.fromJson(json.decode(response.body),
            int.parse(item.tmdbId), int.parse(item.movieId));
        if (movie != null) {
          item.movie = movie;
        }
      } else {
        print("NAO ENCONTRADO NO TMDB: " + item.tmdbId.toString());
      }
    }

    return list.where((element) => element.movie != null).toList();
  }

  static Future<bool> add(MyList item) async {
    final response = await http.post(await API.urlRecommender("mylist"),
        headers: await API.header(), body: jsonEncode(item.toJson()));

    if (response.statusCode == 200) {
      print(response.body);
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> delete(MyList item) async {
    final response = await http.delete(API.urlRecommender("mylist/" + item.id),
        headers: await API.header());

    if (response.statusCode == 200) {
      print(response.body);
      return true;
    } else {
      return false;
    }
  }
}
