import 'package:app_system_recommender/model/Rating.dart';

class Recommender {
  int _id;
  int _imdb;
  int _tmdb;
  double _rating;
  Rating _userRating;

  Recommender(this._id, this._imdb, this._tmdb, this._rating, this._userRating);

  Recommender.fromJson(Map<String, dynamic> json)
      : _id = int.parse(json['id']),
        _imdb = int.parse(json['imdb']),
        _tmdb = int.parse(json['tmdb']),
        _rating = json['rating'];

  double get rating => _rating;

  set rating(double value) {
    _rating = value;
  }

  int get tmdb => _tmdb;

  set tmdb(int value) {
    _tmdb = value;
  }

  int get imdb => _imdb;

  set imdb(int value) {
    _imdb = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }


  Rating get userRating => _userRating;

  set userRating(Rating value) {
    _userRating = value;
  }

  @override
  String toString() {
    return tmdb.toString();
  }

  static List<String> toRecommender(List<Recommender> list){
    List<String> result = new List();

    for(Recommender recommender in list){
      result.add(recommender.tmdb.toString());
    }

    return result;
  }
}
