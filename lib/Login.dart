import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:encrypt/encrypt.dart' as crypt;
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


                        // String url = "http://162.144.70.234/~whitworth/login.php";
                        // http.Response response;

                        // // Set up encrypter
                        // final key = crypt.Key.fromBase64("AAECAwQFBgcICQoLDA0ODxAREhMUFRYXGBkaGxwdHh8=");
                        // // final iv = crypt.IV.fromBase64(""); // TODO: Add in and change mode to cbc if Kristen can figure it out
                        // final encrypter = crypt.Encrypter(crypt.AES(key, mode: crypt.AESMode.ecb));

                        // // Encrypt package to send
                        // final encrypted = encrypter.encrypt("{\"username\":\"${username.text}\",\"password\":\"${password.text}\"}");
                        // // final decrypted = encrypter.decrypt(crypt.Encrypted.fromBase64(encrypted.base64));

                        // // catch an exception if there's no internet connection
                        // try {
                        //   // Send package
                        //   response = await http.post(url, body: encrypted.base64);
                        // } catch (e) {
                        //   return snackKey.currentState.showSnackBar(SnackBar(
                        //     content: Text("Something went wrong, check your connection and try again."),
                        //     duration: Duration(seconds: 2)
                        //   ));
                        // }

                        // // Decrypt response body
                        // String body = encrypter.decrypt(crypt.Encrypted.fromBase64(response.body.trim()));

                        // // three possible failures that we want to handle slightly differently
                        // if (response.statusCode != 200) {
                        //   return snackKey.currentState.showSnackBar(SnackBar(
                        //     content: Text("Something went wrong, check your connection and try again."),
                        //     duration: Duration(seconds: 2)
                        //   ));
                        // } else if (body == "Username not found") {
                        //   return snackKey.currentState.showSnackBar(SnackBar(
                        //     content: Text("Username not found."),
                        //     duration: Duration(seconds: 2)
                        //   ));
                        // } else if (body == "Incorrect Password") {
                        //   return snackKey.currentState.showSnackBar(SnackBar(
                        //     content: Text("Incorrect password."),
                        //     duration: Duration(seconds: 2)
                        //   ));
                        // // we found the username and password pair in the database
                        // } else {
                        //   // Response body comes in json format with the account's role as the first value
                        //   List<dynamic> json = jsonDecode(body);
                        //   String role = json[0];
                        //   Navigator.pushReplacement (
                        //     context,
                        //     // route to a new page based on the role of the account
                        //     PageRouteBuilder(
                        //       pageBuilder: (context, animation1, animation2) {
                        //         return Admin(username: username.text, role: roleEnum);
                        //       }
                        //     )
                        //   );
                        //   return snackKey.currentState.showSnackBar(SnackBar(
                        //     content: Text("Something went wrong, try again."),
                        //     duration: Duration(seconds: 2)
                        //   ));
                        // }
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
