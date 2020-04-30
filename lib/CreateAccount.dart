import 'package:flutter/material.dart';
import 'Home.dart';
import 'utilClasses.dart';

class CreateAccount extends StatelessWidget {
  CreateAccount({Key key}) : super(key: key);

  final formKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final pass = TextEditingController();
  final confirmPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      controller: pass,
                      hintText: "Password",
                      obscureText: true,
                      validation: (value) {
                        if (value.isEmpty) {
                          return "Password cannot be empty";
                        } else if (value.length <= 8) {
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
                        if (value != pass.text) {
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
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          // TODO: Send data
                          Navigator.pushReplacement (
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) {
                                return Home(username: username.text);
                              }
                            )
                          );
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
