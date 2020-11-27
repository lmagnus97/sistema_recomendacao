import 'dart:async';
import 'dart:convert';
import 'package:app_system_recommender/dao/API.dart';
import 'package:app_system_recommender/model/Character.dart';
import 'package:app_system_recommender/model/Movie.dart';
import 'package:app_system_recommender/model/Rating.dart';
import 'package:app_system_recommender/model/Recommender.dart';
import 'package:app_system_recommender/util/AppUtil.dart';
import 'package:http/http.dart' as http;

class RatingDAO {
  static Future<List<Rating>> getAllFromServer() async {
    final response = await http.get(await API.urlRecommender("ratings/" + AppUtil.getIdUser()),
        headers: await API.header());
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      return data.map<Rating>((json) => Rating.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar dados do servidor');
    }
  }

  static Future<List<Rating>> getAll() async {
    List<Rating> listRatings = await RatingDAO.getAllFromServer();

    for (Rating rating in listRatings) {
      final response = await http.get(
          API.urlTMDB(
              "3/movie/" + rating.tmdbId.toString() + "?language=pt-BR"),
          headers: await API.header());

      if (response.statusCode == 200) {
        Movie movie = Movie.fromJson(json.decode(response.body),
            int.parse(rating.tmdbId), int.parse(rating.movieId));
        if (movie != null) {
          rating.movie = movie;
        }
      } else {
        print("NAO ENCONTRADO NO TMDB: " + rating.tmdbId.toString());
      }
    }

    return listRatings.where((element) => element.movie != null).toList();
  }

  static Future<bool> add(Rating rating) async {
    final response = await http.post(await API.urlRecommender("rating"),
        headers: await API.header(), body: jsonEncode(rating.toJson()));

    if (response.statusCode == 200) {
      print(response.body);
      return true;
    } else {
      return false;
    }
  }
}
