import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/RouteGenerator.dart';
import 'package:whatsapp_clone/screens/Home.dart';
import 'package:whatsapp_clone/screens/Signup.dart';
import 'package:whatsapp_clone/model/User.dart' as UserModel;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _emailController = TextEditingController(text: "marcelo.s.benedito@gmail.com");
  TextEditingController _passwordController = TextEditingController(text: "1234567");
  String _errorMessage = "";

  _validateFields() {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (password.isNotEmpty && password.length > 6) {
        setState(() {
          _errorMessage = "";
          UserModel.User user = UserModel.User();
          user.email = email;
          user.password = password;
          _signinUser(user);
        });
      } else {
        setState(() {
          _errorMessage = "Password - Must not be empty and greater than 6 characters";
        });
      }
    } else {
      setState(() {
        _errorMessage = "E-mail - Must not be empty and valid address";
      });
    }
  }

  _signinUser(UserModel.User user) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signInWithEmailAndPassword(
      email: user.email,
      password: user.password
    ).then((firebaseUser) {
      Navigator.pushReplacementNamed(context, RouteGenerator.HOME_ROUTE);
    }).catchError((error) {
      setState(() {
        _errorMessage = "Authentication failed. Check e-mail and password and try again.";
      });
    });
  }

  Future _verifyLoggedUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    //auth.signOut();
    User loggedUser = await auth.currentUser;
    if (loggedUser != null) {
      Navigator.pushReplacementNamed(context, RouteGenerator.HOME_ROUTE);
    }
  }

  @override
  void initState() {
    _verifyLoggedUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xff075E54)),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _emailController,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "E-mail",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Password",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32))),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.green,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)
                    ),
                    onPressed: () {
                      _validateFields();
                    },
                  ),
                ),
                Center(
                  child: GestureDetector(
                    child: Text(
                      "Don't have an account? Sign up!",
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Signup()
                        )
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      _errorMessage,
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
