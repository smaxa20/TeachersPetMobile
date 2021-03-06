import 'package:flutter/material.dart';
import 'Home.dart';
import 'CreateAccount.dart';
import 'auth.dart';
import 'utilClasses.dart';

class Login extends StatelessWidget {
  Login({Key key}) : super(key: key);

  final snackKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final password = TextEditingController();

  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: snackKey,
      backgroundColor: white1,
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
                        }
                        return null;
                      },
                    ),
                    // Container(height: 10, width: 0),
                    // TransparentButton(
                    //   text: "Forgot Password", 
                    //   color: green2,
                    //   onTap: () {
                    //     // TODO: Build forgot password modal
                    //     showDialog(
                    //       context: context,
                    //       builder: (context) {
                    //         return AlertDialog(title: Text("Sorry... Try harder to remember"));
                    //       }
                    //     );
                    //   }
                    // ),
                    Container(height: 40, width: 0),
                    FilledButton(
                      text: "Go",
                      color: green3,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                      onPressed: () async {
                        if (formKey.currentState.validate()) {
                          dynamic result = await auth.signInEmail(username.text, password.text);
                          if (result == null) {
                            snackKey.currentState.showSnackBar(SnackBar(
                              content: Text("Invalid credentials. Please try again."),
                              duration: Duration(seconds: 2)
                            ));
                          } else {
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
                    TransparentButton(
                      text: "Create Account",
                      color: green2,
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) {
                              return CreateAccount();
                            }
                          )
                        );
                      }
                    )
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
