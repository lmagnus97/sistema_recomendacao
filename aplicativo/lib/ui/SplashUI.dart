import 'package:app_system_recommender/dao/RecommenderDAO.dart';
import 'package:app_system_recommender/model/Recommender.dart';
import 'package:app_system_recommender/ui/RegisterUI.dart';
import 'package:app_system_recommender/util/AppTheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashUI extends StatefulWidget {
  @override
  _SplashUIState createState() => _SplashUIState();
}

class _SplashUIState extends State<SplashUI> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: SpinKitDualRing(
                color: AppTheme.accent,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    init();
    load();
    super.initState();
  }

  load() async{
    List<Recommender> dataRecommender = await RecommenderDAO.getAll();
    print(dataRecommender.toString());
  }

  Future init() async {
    await Firebase.initializeApp();
    User user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/login', (Route<dynamic> route) => false,
          arguments: RegisterUI());
    }
  }
}
