import 'dart:async';
import 'dart:convert';
import 'package:app_system_recommender/util/AppUtil.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' as Fire;

class API {
  static String DOMAIN_URL_TMDB = "https://api.themoviedb.org/";

  static String urlTMDB(String destination) {
    return DOMAIN_URL_TMDB + destination;
  }

  static Future<String> urlRecommender(String destination) async {
    String ip = await AppUtil.getIP();
    return "http://$ip:5000/$destination";
  }

  static String urlImage(String image) {
    return "http://image.tmdb.org/t/p/w185" + image;
  }

  static Future<Map<String, String>> header() async {
    String key =
        "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyZWVlOTg5MDAxNmNhY2RiZjQzN2UxNDk3MTc0Y2FmYiIsInN1YiI6IjVmYTk3ZTRjYWJmOGUyMDA0MDQzZjUxMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.J2TetuXPrwBgtPX6mEcRN724EJaAiZ7PKQmGew7hPoU";

    return {
      'Content-Type': 'application/json;charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $key'
    };
  }

  static Future<bool> getConnStatus(String ip) async {
    print("TESTE DE CONEXAO");
    try{
      final response = await http.get("http://$ip:5000/conn",
          headers: await API.header());

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }catch(e){
      print(e.toString());
      return false;
    }
  }
}
