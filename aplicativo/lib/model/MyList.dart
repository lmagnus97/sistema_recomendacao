import 'package:app_system_recommender/model/Movie.dart';

class MyList {
  String _id;
  String _userId;
  String _movieId;
  String _tmdbId;
  String _timestamp;
  Movie _movie;

  MyList(this._id, this._userId, this._movieId, this._tmdbId, this._timestamp, this._movie);

  MyList.fromJson(Map<String, dynamic> json)
      : _id = json['_id'],
        _userId = json['userId'],
        _movieId = json['movieId'],
        _tmdbId = json['tmdbId'],
        _timestamp = json['timestamp'];

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'movieId': movieId,
    'tmdbId': tmdbId,
    'timestamp': timestamp
  };

  String get timestamp => _timestamp;

  set timestamp(String value) {
    _timestamp = value;
  }

  String get tmdbId => _tmdbId;

  set tmdbId(String value) {
    _tmdbId = value;
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

  @override
  String toString() {
    return 'MyList{_id: $_id, _userId: $_userId, _movieId: $_movieId, _tmdbId: $_tmdbId, _timestamp: $_timestamp, _movie: $_movie}';
  }
}
