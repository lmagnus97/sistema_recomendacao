import 'package:app_system_recommender/dao/UserDAO.dart';
import 'package:app_system_recommender/model/User.dart' as mUser;
import 'package:app_system_recommender/ui/LoginUI.dart';
import 'package:app_system_recommender/util/AppTheme.dart';
import 'package:app_system_recommender/util/AppUtil.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RegisterUI extends StatefulWidget {
  @override
  _RegisterUIState createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {
  TextEditingController controllerName = new TextEditingController();
  TextEditingController controllerPhone = new TextEditingController();
  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerPassword = new TextEditingController();
  final _formValidate = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Widget _entryField(String title, TextEditingController controller,
      IconData iconData,
      {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: AppTheme.primary[300]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            style: TextStyle(color: Colors.white),
            obscureText: isPassword,
            controller: controller,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15),
                prefixIcon: Icon(
                  iconData,
                  color: Colors.white,
                ),
                hintText: title,
                hintStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
                border: InputBorder.none),
          )
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () => _signUp(),
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppTheme.accent,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Text(
          'Criar conta',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _formsWidget() {
    return Form(
        key: _formValidate,
        child: Column(
          children: <Widget>[
            _entryField("Nome", controllerName, Icons.account_circle_sharp),
            _entryField("Telefone", controllerPhone, Icons.phone_android),
            _entryField("Email", controllerEmail, Icons.mail),
            _entryField("Senha", controllerPassword, Icons.vpn_key,
                isPassword: true),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary[600],
      appBar: AppBar(
        title: Text("Criar uma nova conta"),
      ),
      body: Container(
        child: _isLoading
            ? Center(
          child: SpinKitDualRing(
            color: AppTheme.accent,
            size: 32,
          ),
        )
            : Center(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
              height: 400,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: AppTheme.primary[500],
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: AppTheme.primary[600],
                        offset: Offset(2, 4),
                        blurRadius: 5,
                        spreadRadius: 2)
                  ]),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: _formsWidget(),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: _submitButton(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _signUp() async {
    if (_formValidate.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: controllerEmail.text,
        password: controllerPassword.text,
      )
          .then((user) {
        setState(() {
          _isLoading = false;
          _signIn(user.user.uid);
        });
      }).catchError((onError) {
        print("ERRO LOGIN: " + onError.toString());
        AppUtil.dialogMessage(context, "Falha!", "Email em uso!", DialogType.ERROR);
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  Future _signIn(String uid) async {
    mUser.User user = new mUser.User(
        uid, controllerName.text, controllerPhone.text,
        controllerEmail.text, DateTime
        .now()
        .millisecondsSinceEpoch
        .toString());
    await UserDAO.add(user);

    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.popAndPushNamed(context, "/");
    } else {
      Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => LoginUI(),
        ),
      );
    }
  }
}
