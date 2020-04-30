import 'package:flutter/material.dart';
import 'Home.dart';
import 'auth.dart';
import 'database.dart';
import 'utilClasses.dart';

class CreateAccount extends StatelessWidget {
  CreateAccount({Key key}) : super(key: key);

  final formKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final password = TextEditingController();
  final confirmPass = TextEditingController();

  final AuthService auth = AuthService();
  final DatabaseService db = DatabaseService();
  final snackKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: snackKey,
      backgroundColor: white1,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: green4),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            PercentageContainer(percentage: 0.25),
            Text(
              "Teacher's Pet",
              style: TextStyle(color: green4, fontFamily: "Times New Roman", fontSize: 48)
            ),
            Flexible(child: Container(height: 80, width: 0)),
            Container(
              width: 320,
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    FilledInput(
                      controller: username,
                      hintText: "Username",
                      validation: (value) {
                        if (value.isEmpty) {
                          return "Username cannot be empty";
                        }
                        return null;
                      },
                    ),
                    Container(height: 20, width: 0),
                    FilledInput(
                      controller: password,
                      hintText: "Password",
                      obscureText: true,
                      validation: (value) {
                        if (value.isEmpty) {
                          return "Password cannot be empty";
                        } else if (value.length < 8) {
                          return "Password must be 8+ characters long.";
                        }
                        return null;
                      },
                    ),
                    Container(height: 20, width: 0),
                    FilledInput(
                      hintText: "Confirm Password",
                      obscureText: true,
                      validation: (value) {
                        if (value != password.text) {
                          return "Passwords don't match";
                        }
                        return null;
                      },
                    ),
                    Container(height: 40, width: 0),
                    FilledButton(
                      text: "Go",
                      color: green3,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                      onPressed: () async {
                        if (formKey.currentState.validate()) {
                          // TODO: Send data
                          dynamic result = await auth.registerEmail(username.text, password.text);
                          if (result == null) {
                            snackKey.currentState.showSnackBar(SnackBar(
                              content: Text("Invalid email or password. Please try again."),
                              duration: Duration(seconds: 2)
                            ));
                          } else {
                            print(result.uid);
                            db.addUid(result.uid);
                            db.addClass("Class0", "New Class");
                            Navigator.pushReplacement (
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation1, animation2) {
                                  return Home(uid: result.uid);
                                }
                              )
                            );
                          }
                        }
                      }
                    ),
                    Container(height: 40, width: 0),
                  ]
                )
              )
            )
          ],
        )
      ),
    );
  }
}
