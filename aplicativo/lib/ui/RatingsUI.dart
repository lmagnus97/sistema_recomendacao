import 'package:app_system_recommender/dao/API.dart';
import 'package:app_system_recommender/dao/MoviesDAO.dart';
import 'package:app_system_recommender/dao/RatingDAO.dart';
import 'package:app_system_recommender/model/Rating.dart';
import 'package:app_system_recommender/ui/MovieDetailUI.dart';
import 'package:app_system_recommender/util/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RatingsUI extends StatefulWidget {
  @override
  _RatingsUIState createState() => _RatingsUIState();
}

class _RatingsUIState extends State<RatingsUI> {
  Future<List<Rating>> dataRatings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary[600],
      appBar: AppBar(
        title: Text("Minhas avaliações"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<List<Rating>>(
          future: dataRatings,
          builder:
              (BuildContext context, AsyncSnapshot<List<Rating>> snapshot) {
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

  Widget itemMovie(Rating rating) {
    return InkWell(
      onTap: () => "",
      child: Container(
        width: double.infinity,
        height: 110,
        margin: EdgeInsets.all(8),
        color: AppTheme.primary[500],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            rating.movie.posterPath != null
                ? Image.network(
                    API.urlImage(rating.movie.posterPath),
                    fit: BoxFit.fitWidth,
                    height: 110,
                  )
                : Container(),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 8, right: 8),
                  child: Text(
                    rating.movie.title,
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
                      EdgeInsets.only(top: 5, left: 8, right: 8),
                  child: RatingBar.builder(
                    initialRating: rating.rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    dataRatings = RatingDAO.getAll();

    super.initState();
  }
}
