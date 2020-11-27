import 'package:app_system_recommender/model/Movie.dart';

class Rating {
  String _id;
  String _userId;
  String _movieId;
  double _rating;
  String _timestamp;
  String _tmdbId;
  Movie _movie;

  Rating(this._id, this._userId, this._movieId, this._rating, this._timestamp,
      this._movie, this._tmdbId);

  Rating.fromJson(Map<String, dynamic> json)
      : _id = json['_id'],
        _userId = json['userId'],
        _movieId = json['movieId'],
        _rating = double.parse(json['rating']),
        _timestamp = json['timestamp'],
        _tmdbId = json['tmdb'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'movieId': movieId,
        'rating': rating.toString(),
        'timestamp': timestamp
      };

  String get timestamp => _timestamp;

  set timestamp(String value) {
    _timestamp = value;
  }

  double get rating => _rating;

  set rating(double value) {
    _rating = value;
  }

  String get movieId => _movieId;

  set movieId(String value) {
    _movieId = value;
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  Movie get movie => _movie;

  set movie(Movie value) {
    _movie = value;
  }

  String get tmdbId => _tmdbId;

  set tmdbId(String value) {
    _tmdbId = value;
  }

  @override
  String toString() {
    return 'Rating{_id: $_id, _userId: $_userId, _movieId: $_movieId, _rating: $_rating, _timestamp: $_timestamp, _tmdbId: $_tmdbId, _movie: $_movie}';
  }
}
