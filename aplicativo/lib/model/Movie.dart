import 'package:app_system_recommender/model/Genre.dart';
import 'package:app_system_recommender/model/Rating.dart';

class Movie {
  int _id;
  String _originalTitle;
  List<Genre> _listaGenres;
  String _originalLanguage;
  String _overview;
  String _posterPath;
  String _title;
  String _releaseDate;
  int _tmdb;
  Rating _rating;

  Movie(
      this._id,
      this._originalTitle,
      this._listaGenres,
      this._originalLanguage,
      this._overview,
      this._posterPath,
      this._releaseDate,
      this._title,
      this._tmdb);

  Movie.fromJson(Map<String, dynamic> json, int tmdb, int id)
      : _id = id,
        _originalTitle = json['original_title'],
        _overview = json['overview'],
        _posterPath = json['poster_path'],
        _releaseDate = json['release_date'],
        _originalLanguage = json['original_language'],
        _title = json['title'],
        _listaGenres = json['genres'] != null
            ? json['genres'].map<Genre>((json) => Genre.fromJson(json)).toList()
            : [],
        _tmdb = tmdb;

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get releaseDate => _releaseDate;

  set releaseDate(String value) {
    _releaseDate = value;
  }

  String get posterPath => _posterPath;

  set posterPath(String value) {
    _posterPath = value;
  }

  String get overview => _overview;

  set overview(String value) {
    _overview = value;
  }

  String get originalLanguage => _originalLanguage;

  set originalLanguage(String value) {
    _originalLanguage = value;
  }

  List<Genre> get listaGenres => _listaGenres;

  set listaGenres(List<Genre> value) {
    _listaGenres = value;
  }

  String get originalTitle => _originalTitle;

  set originalTitle(String value) {
    _originalTitle = value;
  }

  int get tmdb => _tmdb;

  set tmdb(int value) {
    _tmdb = value;
  }


  int get id => _id;

  set id(int value) {
    _id = value;
  }

  Rating get rating => _rating;

  set rating(Rating value) {
    _rating = value;
  }

  @override
  String toString() {
    return 'Movie{_id: $_id, _originalTitle: $_originalTitle, _listaGenres: $_listaGenres, _originalLanguage: $_originalLanguage, _overview: $_overview, _posterPath: $_posterPath, _title: $_title, _releaseDate: $_releaseDate, _tmdb: $_tmdb}';
  }
}
