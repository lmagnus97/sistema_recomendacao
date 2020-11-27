import 'package:app_system_recommender/dao/API.dart';
import 'package:app_system_recommender/dao/MoviesDAO.dart';
import 'package:app_system_recommender/dao/RatingDAO.dart';
import 'package:app_system_recommender/model/Character.dart';
import 'package:app_system_recommender/model/Movie.dart';
import 'package:app_system_recommender/model/Rating.dart';
import 'package:app_system_recommender/util/AppTheme.dart';
import 'package:app_system_recommender/util/AppUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class MovieDetailUI extends StatefulWidget {
  int tmdb;
  int movieId;

  MovieDetailUI(this.tmdb, this.movieId);

  @override
  _MovieDetailUIState createState() => _MovieDetailUIState();
}

class _MovieDetailUIState extends State<MovieDetailUI> {
  Future<Movie> mMovie;
  Future<List<Character>> dataSquad;
  double mRating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary[600],
      appBar: AppBar(
        title: Text("Detalhes do filme"),
      ),
      body: FutureBuilder<Movie>(
        future: mMovie,
        builder: (BuildContext context, AsyncSnapshot<Movie> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: Center(
                  child: SpinKitDualRing(
                    color: AppTheme.accent,
                    size: 32,
                  ),
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text("Ocorre um erro, por favor tente"),
                  ),
                );
              } else
                return SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 230,
                          color: AppTheme.primary[500],
                          child: Row(
                            children: [
                              Image.network(
                                  API.urlImage(snapshot.data.posterPath)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 15, bottom: 5),
                                      child: Text(
                                        snapshot.data.title,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        "(" + snapshot.data.originalTitle + ")",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      margin:
                                          EdgeInsets.fromLTRB(15, 5, 15, 10),
                                      height: 1,
                                      color: Colors.white24,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Text(
                                        AppUtil.convertToDate(
                                                snapshot.data.releaseDate) +
                                            " | " +
                                            AppUtil.genresToList(
                                                snapshot.data.listaGenres),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 11),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    RatingBar.builder(
                                      initialRating:
                                          snapshot.data.rating != null
                                              ? snapshot.data.rating.rating
                                                  .toDouble()
                                              : 0,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                        mRating = rating;
                                      },
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                    ),
                                    Card(
                                      color: AppTheme.accent,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: FlatButton(
                                          onPressed: () =>
                                              sendRating(snapshot.data.rating),
                                          child: Text(
                                            "Avaliar",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        snapshot.data.overview != null &&
                                snapshot.data.overview.length > 0
                            ? Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.fromLTRB(5, 15, 5, 10),
                                color: AppTheme.primary[500],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Sobre o filme",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 10, left: 10),
                                      child: Text(
                                        snapshot.data.overview,
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(15),
                          margin: EdgeInsets.fromLTRB(5, 15, 5, 10),
                          color: AppTheme.primary[500],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Elenco",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              FutureBuilder<List<Character>>(
                                future: dataSquad,
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<Character>> snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return Center(
                                        child: SpinKitDualRing(
                                          color: AppTheme.accent,
                                          size: 32,
                                        ),
                                      );
                                    default:
                                      if (snapshot.hasError) {
                                        return Text(
                                          "Ocorreu um erro...",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        );
                                      } else
                                        return snapshot.data.length > 0
                                            ? Container(
                                                width: double.infinity,
                                                child: ListView.builder(
                                                  physics: ScrollPhysics(),
                                                  shrinkWrap: true,
                                                  primary: false,
                                                  itemCount:
                                                      snapshot.data.length,
                                                  padding: EdgeInsets.only(
                                                      top: 5,
                                                      bottom: 10,
                                                      left: 10,
                                                      right: 10),
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return itemSquad(
                                                        snapshot.data[index]);
                                                  },
                                                ),
                                              )
                                            : Text(
                                                "Sem informações de elenco",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              );
                                  }
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
          }
        },
      ),
    );
  }

  Widget itemSquad(Character character) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 5, 10, 5),
      child: Row(
        children: [
          character.profilePath != null
              ? Image.network(
                  API.urlImage(character.profilePath),
                  height: 64,
                  width: 64,
                )
              : Container(),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  character.name,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  character.character,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  sendRating(Rating userRating) {
    if (mRating > 0) {
      Rating rating = new Rating(
          userRating != null ? userRating.id : null,
          AppUtil.getIdUser(),
          widget.movieId.toString(),
          mRating,
          DateTime.now().millisecondsSinceEpoch.toString(),
          null,
          null);

      RatingDAO.add(rating)
          .then((value) => {
                AppUtil.dialogMessage(context, "Sucesso!",
                    "Sua avaliação foi registrada", DialogType.SUCCES)
              })
          .catchError((onError) {
        AppUtil.dialogMessage(context, "Erro!", "Falha ao registrar avaliação!",
            DialogType.ERROR);
      });
    } else {
      AppUtil.dialogMessage(
          context, "Erro!", "Falha ao registrar avaliação!", DialogType.ERROR);
    }
  }

  @override
  void initState() {
    mMovie = MoviesDAO.get(widget.tmdb.toString(), widget.movieId.toString());
    dataSquad = MoviesDAO.getSquad(widget.tmdb.toString());
    mMovie.then((value) => {print(value.toString())});

    super.initState();
  }
}
