import 'package:app_system_recommender/dao/API.dart';
import 'package:app_system_recommender/ui/RegisterUI.dart';
import 'package:app_system_recommender/util/AppUtil.dart';
import 'package:app_system_recommender/util/AppTheme.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginUI extends StatefulWidget {
  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerPassword = new TextEditingController();
  TextEditingController controllerIP = new TextEditingController();
  bool _isLoading = false;
  Future<String> appIP;

  @override
  void initState() {
    super.initState();
    appIP = AppUtil.getIP();
    sign();
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
          TextField(
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
                  border: InputBorder.none))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () => login(context),
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
          'Entrar',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () =>
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) => RegisterUI(),
              transitionsBuilder: (c, anim, a2, child) =>
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-1, 0),
                      end: Offset.zero,
                    ).animate(anim),
                    child: child,
                  ),
            ),
          ),
      child: Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        color: AppTheme.primary[400],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Criar uma nova conta',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Email", controllerEmail, Icons.mail),
        _entryField("Senha", controllerPassword, Icons.vpn_key,
            isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary[600],
      appBar: AppBar(
        title: Text("Recomendador de filmes"),
        centerTitle: true,
      ),
      body: FutureBuilder<String>(
        future: appIP,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
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
                return snapshot.data == null
                    ? Center(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(15),
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(5)),
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
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10)),
                                  color: AppTheme.primary[300]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  TextField(
                                      style: TextStyle(color: Colors.white),
                                      controller: controllerIP,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(15),
                                          prefixIcon: Icon(
                                            Icons.signal_cellular_alt,
                                            color: Colors.white,
                                          ),
                                          hintText: "Digite o IP do servidor...",
                                          hintStyle: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                          border: InputBorder.none))
                                ],
                              ),
                            )
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                            child: InkWell(
                              onTap: () => connect(),
                              child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                padding:
                                EdgeInsets.symmetric(vertical: 15),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppTheme.accent,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(5)),
                                ),
                                child: Text(
                                  'Conectar ao seridor',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                )
                    : Container(
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
                        margin: EdgeInsets.all(15),
                        height: 410,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(5)),
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
                              child: _emailPasswordWidget(),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  15, 15, 15, 0),
                              child: _submitButton(),
                            ),
                            FlatButton(
                              onPressed: () => resetPassword(),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10),
                                alignment: Alignment.centerRight,
                                child: Text('Esqueceu sua senha?',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white)),
                              ),
                            ),
                            FlatButton(
                              onPressed: () => {
                                AppUtil.saveIP(null).then((value) => {
                                Navigator.of(context)
                                    .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false)
                                })
                              },
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Text('Trocar IP',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white)),
                              ),
                            ),
                            _createAccountLabel()
                          ],
                        ),
                      ),
                    ),
                  ),
                );
          }
        },
      ),
    );
  }

  Future sign() async {
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  login(BuildContext context) async {
    if (controllerEmail.text.length == 0) {
      AppUtil.dialogMessage(
          context, "Aviso!", "Digite o email!", DialogType.INFO);
    } else if (controllerPassword.text.length == 0) {
      AppUtil.dialogMessage(
          context, "Aviso!", "Digite a senha!", DialogType.INFO);
    } else {
      setState(() {
        _isLoading = true;
      });
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: controllerEmail.text.trim(),
          password: controllerPassword.text.trim())
          .then((user) =>
      {
        confirmLogin(user.user),
      })
          .catchError((onError) {
        setState(() {
          _isLoading = false;
          AppUtil.dialogMessage(context, "Falha!", "Verifique o email e senha!",
              DialogType.ERROR);
        });
      });
    }
  }

  Future confirmLogin(User user) async {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  connect() async {
    if (await API.getConnStatus(controllerIP.text)) {
      AppUtil.saveIP(controllerIP.text)
          .then((value) =>
      {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(
            '/login',
                (Route<dynamic>
            route) =>
            false)
      })
          .catchError((onError) {
        AppUtil.dialogMessage(
            context,
            "Falha",
            "Falha ao salvar IP",
            DialogType.ERROR);
      });
    } else {
      AppUtil.dialogMessage(
          context, "Falha na conexão", "Servidor sem acesso ou IP incorreto!",
          DialogType.ERROR);
    }
  }

  resetPassword() {
    if (controllerEmail.text.length < 5) {
      AppUtil.dialogMessage(context, "Aviso!",
          "Digite seu email no campo Email", DialogType.INFO);
    } else {
      FirebaseAuth.instance
          .sendPasswordResetEmail(email: controllerEmail.text)
          .then((value) {
        AppUtil.dialogMessage(context, "Sucesso!",
            "Redefinição enviada para seu email!", DialogType.SUCCES);
      }).catchError((error) {
        print("Erro redefinição de senha: " + error);
        AppUtil.dialogMessage(
            context, "Falha!", "Verique o email inserido!", DialogType.ERROR);
      });
    }
  }
}
