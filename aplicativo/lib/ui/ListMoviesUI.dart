import 'package:app_system_recommender/dao/API.dart';
import 'package:app_system_recommender/dao/MoviesDAO.dart';
import 'package:app_system_recommender/dao/MyListDAO.dart';
import 'package:app_system_recommender/model/Movie.dart';
import 'package:app_system_recommender/model/MyList.dart';
import 'package:app_system_recommender/ui/MovieDetailUI.dart';
import 'package:app_system_recommender/util/AppTheme.dart';
import 'package:app_system_recommender/util/AppUtil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ListMoviesUI extends StatefulWidget {
  @override
  _ListMoviesUIState createState() => _ListMoviesUIState();
}

class _ListMoviesUIState extends State<ListMoviesUI> {
  Future<List<MyList>> dataList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary[600],
      appBar: AppBar(
        title: Text("Minha lista"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<List<MyList>>(
          future: dataList,
          builder:
              (BuildContext context, AsyncSnapshot<List<MyList>> snapshot) {
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
                    "Ocorreu um erro... " + snapshot.error.toString(),
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  );
                } else
                  return snapshot.data.length > 0
                      ? ListView.builder(
                          physics: ScrollPhysics(),
                          primary: true,
                          itemCount: snapshot.data.length,
                          padding: EdgeInsets.only(
                              top: 5, bottom: 10, left: 10, right: 10),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return itemMovie(snapshot.data[index]);
                          },
                        )
                      : Text(
                          "Sem filmes na sua lista",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        );
            }
          },
        ),
      ),
    );
  }

  Widget itemMovie(MyList item) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) =>
              MovieDetailUI(item.movie.tmdb, item.movie.id),
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
        width: double.infinity,
        height: 100,
        margin: EdgeInsets.all(8),
        color: AppTheme.primary[500],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              API.urlImage(item.movie.posterPath),
              fit: BoxFit.fitWidth,
              height: 100,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 8, right: 8),
                  child: Text(
                    item.movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 5, left: 8, right: 8, bottom: 12),
                  child: Text(
                    AppUtil.convertToDate(item.movie.releaseDate),
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ],
            )),
            Center(
              child: Card(
                color: AppTheme.accent,
                margin: EdgeInsets.only(left: 8, right: 10, bottom: 8),
                child: Container(
                  height: 40,
                  width: 40,
                  child: FlatButton(
                    onPressed: () => delete(item),
                    child: Text(
                      "X",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  delete(MyList item) {
    MyListDAO.delete(item).then((value) => {
      setState((){
        dataList = MyListDAO.getAll();
      })
    }).catchError((onError) {
      print("ERROR: " + onError.toString());
    });
  }

  @override
  void initState() {
    dataList = MyListDAO.getAll();

    super.initState();
  }
}
