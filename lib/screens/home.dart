import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_restaurants/repositories/user.dart';
import 'package:flutter_restaurants/screens/restaurant.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserRepository.instance(),
      child: Consumer(builder: (context, UserRepository user, _) {
        switch (user.status) {
          case Status.Uninitialized:
            return Splash();
          case Status.Unauthenticated:
          case Status.Authenticating:
            return LoginPage();
          case Status.Authenticated:
            return RestaurantListPage();
        }
      }),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text('Splash screen'),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _email;
  TextEditingController _password;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text('Flutterレストラン'),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _email,
                  validator: (value) =>
                      (value.isEmpty) ? "Please Enter Email" : null,
                  style: style,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: "Email",
                      border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  obscureText: true,
                  controller: _password,
                  validator: (value) =>
                      (value.isEmpty) ? "Please Enter Password" : null,
                  style: style,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: "Password",
                      border: OutlineInputBorder()),
                ),
              ),
              user.status == Status.Authenticating
                  ? Center(child: CircularProgressIndicator())
                  : ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(30.0),
                            color: Colors.brown,
                            child: MaterialButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  if (!await user.signIn(
                                      _email.text, _password.text))
                                    _key.currentState.showSnackBar(SnackBar(
                                      content: Text('間違ってます'),
                                    ));
                                }
                              },
                              child: Text(
                                "ログイン",
                                key: Key('login'),
                                style: style.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(30.0),
                            color: Colors.red,
                            child: MaterialButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  if (!await user
                                      .createUserWithEmailAndPassword(
                                          _email.text, _password.text))
                                    _key.currentState.showSnackBar(SnackBar(
                                      content: Text('会員登録に失敗しました'),
                                    ));
                                }
                              },
                              child: Text(
                                "新規登録",
                                key: Key('signup'),
                                style: style.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
