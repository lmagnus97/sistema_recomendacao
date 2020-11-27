import 'package:app_system_recommender/dao/API.dart';
import 'package:app_system_recommender/dao/MoviesDAO.dart';
import 'package:app_system_recommender/dao/MyListDAO.dart';
import 'package:app_system_recommender/model/Movie.dart';
import 'package:app_system_recommender/model/MyList.dart';
import 'package:app_system_recommender/ui/ListMoviesUI.dart';
import 'package:app_system_recommender/ui/MovieDetailUI.dart';
import 'package:app_system_recommender/ui/RatingsUI.dart';
import 'package:app_system_recommender/util/AppTheme.dart';
import 'package:app_system_recommender/util/AppUtil.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeUI extends StatefulWidget {
  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  Future<List<Movie>> dataRecommender;
  TextEditingController controllerSearch = new TextEditingController();
  String mSearch = "";
  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary[600],
      appBar: AppBar(
        title: Text("Sistema de recomendação"),
        actions: [
          FlatButton(
            onPressed: () => logout(),
            child: Text(
              "Sair",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(8),
              color: AppTheme.primary[500],
              child: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: AppTheme.primary[300],
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            ),
                            hintText: 'Pesquisar filme',
                            hintStyle:
                                TextStyle(color: Colors.white, fontSize: 14)),
                        controller: controllerSearch,
                        onChanged: (text) {
                          setState(() {
                            mSearch = text;
                            if (text.length > 2) {
                              isSearch = true;
                            } else {
                              isSearch = false;
                            }
                          });
                        },
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    isSearch
                        ? IconButton(
                            onPressed: () => setState(() {
                              isSearch = false;
                              mSearch = "";
                              controllerSearch.text = "";
                            }),
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            ),
            isSearch ? _search() : _body()
          ],
        ),
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.all(8),
          color: AppTheme.primary[500],
          child: Column(
            children: [
              FlatButton(
                onPressed: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) => RatingsUI(),
                    transitionsBuilder: (c, anim, a2, child) => SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(anim),
                      child: child,
                    ),
                  ),
                ),
                padding: EdgeInsets.all(10),
                minWidth: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Icon(
                      Icons.star_border,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Minhas avaliações",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    )
                  ],
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) => ListMoviesUI(),
                    transitionsBuilder: (c, anim, a2, child) => SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(anim),
                      child: child,
                    ),
                  ),
                ),
                padding: EdgeInsets.all(10),
                minWidth: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Icon(
                      Icons.list,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Minha lista",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.all(8),
          color: AppTheme.primary[500],
          padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Recomendações",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
              Container(
                height: 40,
                child: FlatButton(
                    onPressed: () => update(),
                    color: Colors.white,
                    child: Text(
                      "Atualizar",
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    )),
              )
            ],
          ),
        ),
        FutureBuilder<List<Movie>>(
          future: dataRecommender,
          builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: SpinKitDualRing(
                      color: AppTheme.accent,
                      size: 32,
                    ),
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Text(
                    "Ocorreu um erro... " + snapshot.error.toString(),
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  );
                } else
                  return snapshot.data.length > 0
                      ? Container(
                          width: double.infinity,
                          height: 400,
                          child: ListView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            primary: false,
                            itemCount: snapshot.data.length,
                            padding: EdgeInsets.only(
                                top: 5, bottom: 10, left: 10, right: 10),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return itemMovie(
                                  snapshot.data[index], snapshot.data);
                            },
                          ),
                        )
                      : Text(
                          "Sem recomendações no momento",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        );
            }
          },
        )
      ],
    );
  }

  Widget _search() {
    return Column(
      children: [
        FutureBuilder<List<Movie>>(
          future: MoviesDAO.search(mSearch),
          builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: SpinKitDualRing(
                      color: AppTheme.accent,
                      size: 32,
                    ),
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Text(
                    "Ocorreu um erro... " + snapshot.error.toString(),
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  );
                } else
                  return snapshot.data.length > 0
                      ? Container(
                          width: double.infinity,
                          height: 400,
                          child: ListView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            primary: false,
                            itemCount: snapshot.data.length,
                            padding: EdgeInsets.only(
                                top: 5, bottom: 10, left: 10, right: 10),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return itemMovie(
                                  snapshot.data[index], snapshot.data);
                            },
                          ),
                        )
                      : Text(
                          "Sem recomendações no momento",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        );
            }
          },
        )
      ],
    );
  }

  Widget itemMovie(Movie movie, List<Movie> listMovies) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) => MovieDetailUI(movie.tmdb, movie.id),
          transitionsBuilder: (c, anim, a2, child) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(anim),
            child: child,
          ),
        ),
      ),
      child: Container(
        height: 400,
        width: 170,
        margin: EdgeInsets.all(8),
        color: AppTheme.primary[500],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            movie.posterPath != null
                ? Image.network(
                    API.urlImage(movie.posterPath),
                    fit: BoxFit.fitWidth,
                    height: 240,
                    width: MediaQuery.of(context).size.width,
                  )
                : Container(
                    height: 240,
                    child: Center(
                      child: Icon(
                        Icons.local_movies_outlined,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 8, right: 8),
              child: Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.clip,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 5, left: 8, right: 8, bottom: 12),
                child: Text(
                  AppUtil.convertToDate(movie.releaseDate),
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
            !isSearch
                ? Center(
                    child: Card(
                      color: AppTheme.accent,
                      margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: FlatButton(
                          onPressed: () => setState(() {
                            addList(movie);
                            listMovies.remove(movie);
                          }),
                          child: Text(
                            "+ Minha lista",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  addList(Movie movie) {
    MyList item = new MyList(
        null,
        AppUtil.getIdUser(),
        movie.id.toString(),
        movie.tmdb.toString(),
        DateTime.now().millisecondsSinceEpoch.toString(),
        movie);
    MyListDAO.add(item)
        .then((value) => {
              AppUtil.dialogMessage(context, "Sucesso!",
                  "Adicionado a sua lista", DialogType.SUCCES)
            })
        .catchError((e) {
      print("ERROR: " + e.toString());
    });
  }

  void logout() {
    FirebaseAuth.instance
        .signOut()
        .then((value) => {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login', (Route<dynamic> route) => false)
            })
        .catchError((onError) {});
  }

  @override
  void initState() {
    dataRecommender = MoviesDAO.getRecommender();

    super.initState();
  }

  update() {
    setState(() {
      dataRecommender = MoviesDAO.getRecommender();
    });
  }
}
