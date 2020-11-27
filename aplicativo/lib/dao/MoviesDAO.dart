import 'dart:async';
import 'dart:convert';
import 'package:app_system_recommender/dao/API.dart';
import 'package:app_system_recommender/dao/RatingDAO.dart';
import 'package:app_system_recommender/dao/RecommenderDAO.dart';
import 'package:app_system_recommender/model/Character.dart';
import 'package:app_system_recommender/model/Movie.dart';
import 'package:app_system_recommender/model/Rating.dart';
import 'package:app_system_recommender/model/Recommender.dart';
import 'package:app_system_recommender/util/AppUtil.dart';
import 'package:http/http.dart' as http;

class MoviesDAO {
  static Future<Movie> get(String tmdbId, String movieId) async {
    //RATING SYSTEM RECOMMENDER
    final responseRating = await http.get(
        await API.urlRecommender(
            "rating/" + AppUtil.getIdUser() + "/" + movieId.toString()),
        headers: await API.header());

    Rating rating;
    if (responseRating.statusCode == 200) {
      rating = Rating.fromJson(json.decode(responseRating.body));
    }

    //TMDB
    final response = await http.get(
        API.urlTMDB("3/movie/" + tmdbId + "?language=pt-BR"),
        headers: await API.header());

    if (response.statusCode == 200) {
      Movie movie = Movie.fromJson(
          json.decode(response.body), int.parse(tmdbId), int.parse(movieId));
      movie.rating = rating;
      return movie;
    } else {
      throw Exception('Falha ao carregar');
    }
  }

  static Future<List<Character>> getSquad(String idMovie) async {
    final response = await http.get(
        API.urlTMDB("3/movie/" + idMovie + "/credits?language=pt-BR"),
        headers: await API.header());

    if (response.statusCode == 200) {
      var data = json.decode(response.body)["cast"] as List;
      List<Character> result =
          data.map<Character>((json) => Character.fromJson(json)).toList();
      if (result.length < 5) {
        return result;
      } else {
        return result.take(5).toList();
      }
    } else {
      throw Exception('Falha ao carregar');
    }
  }

  static Future<List<Movie>> getRecommender() async {
    List<Recommender> listRecommender = await RecommenderDAO.getAll();
    List<Movie> result = new List();

    for (Recommender recommender in listRecommender) {
      final response = await http.get(
          API.urlTMDB(
              "3/movie/" + recommender.tmdb.toString() + "?language=pt-BR"),
          headers: await API.header());

      if (response.statusCode == 200) {
        Movie movie = Movie.fromJson(
            json.decode(response.body),
            int.parse(recommender.tmdb.toString()),
            int.parse(recommender.id.toString()));
        result.add(movie);
      } else {
        print(recommender.tmdb.toString());
      }
    }

    return result;
  }

  static Future<List<Movie>> search(String search) async {
    List<Movie> dataMovies = new List();
    List<Movie> result = new List();

    //GET MOVIES TMDB
    final response = await http.get(
        API.urlTMDB("3/search/movie?query=$search&language=pt-BR"),
        headers: await API.header());

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['results'] as List;
      dataMovies = data
          .map<Movie>((json) => Movie.fromJson(json, json['id'], 0))
          .toList();
    } else {
      throw Exception('Falha ao carregar');
    }

    //GET MOVIES MOVIELENS
    for(Movie movie in dataMovies){
      final response = await http.get(
          await API.urlRecommender("movie/" + movie.tmdb.toString()),
          headers: await API.header());

      print("resposta movielens: " + response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        movie.id = int.parse(data['movieId']);
        result.add(movie);
      }
    }

    return result;

  }
}
