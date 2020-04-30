import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'Login.dart';
import 'ClassActions.dart';
import 'auth.dart';
import 'database.dart';
import 'utilClasses.dart';

class Home extends StatelessWidget {
  Home({Key key, @required this.uid}) : super();

  final String uid;

  @override
  Widget build(BuildContext context) {
    final DatabaseService db = DatabaseService(uid: uid);
    return StreamProvider<QuerySnapshot>.value(
      value: db.classes,
      child: HomeContent(uid: uid)
    );
  }
}

class HomeContent extends StatefulWidget {
  HomeContent({Key key, @required this.uid}) : super();

  final String uid;

  @override
  _HomeContentState createState() => _HomeContentState(uid: uid);
}

class _HomeContentState extends State<HomeContent> {
  _HomeContentState({Key key, @required this.uid}) : super();

  final String uid;

  final newDriverFormKey = GlobalKey<FormState>();
  final snackKey = GlobalKey<ScaffoldState>();

  final AuthService auth = AuthService();

  List<bool> isEditing = [];

  @override
  Widget build(BuildContext context) {

    final DatabaseService db = DatabaseService(uid: uid);
    

    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseService(uid: uid).classes,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List classes = snapshot.data.documents;
          for (var _ in classes) {
            isEditing.add(false);
          }

          return Scaffold(
            key: snackKey,
            backgroundColor: white1,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.phonelink_erase),
                onPressed: () {
                  Navigator.pushReplacement (
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) {
                        auth.signOut();
                        return Login();
                      }
                    )
                  );
                },
              ),
              iconTheme: IconThemeData(color: green4),
              centerTitle: true,
              title: Text(
                "My Classes",
                style: TextStyle(color: green4, fontFamily: "Times New Roman", fontSize: 32)
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Center(
              child: ListView.separated(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1,
                vertical: 32
              ),
              itemCount: classes.length,
              itemBuilder: (context, index) {
                String className = classes[index]["name"];
                TextEditingController editController = TextEditingController();

                Widget title;
                if (isEditing[index]) {
                  title = Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: green4))
                    ),
                    child: TextFormField(
                      controller: editController,
                      autofocus: true,
                      maxLines: 1,
                      style: TextStyle(fontFamily: "Times New Roman", fontSize: 16),
                      decoration: InputDecoration.collapsed(
                        hintText: className,
                        hintStyle: TextStyle(fontFamily: "Times New Roman", fontSize: 16),
                      ),
                      onEditingComplete: () async {
                        if (className != editController.text && editController.text != "") {
                          await db.updateClasses(index, editController.text ?? className);
                          snackKey.currentState.showSnackBar(SnackBar(
                            content: Text("Class name changed!"),
                            duration: Duration(seconds: 2)
                          ));
                        }
                        editController.text = "";
                        setState(() {
                          isEditing[index] = !isEditing[index];
                        });
                      },
                    )
                  );
                } else {
                  title = Text(
                    className,
                    style: TextStyle(fontFamily: "Times New Roman"),
                  );
                }

                return Card(
                  color: Colors.white,
                  elevation: 5,
                  child: Container(
                    height: 56,
                    child: ListTile(
                      title: title,
                      trailing: FilledButton(
                        text: isEditing[index] ? "Done" : "Edit",
                        color: green2,
                        textColor: Colors.black,
                        smallText: true,
                        width: 60,
                        padding: EdgeInsets.all(0),
                        borderRadius: 20,
                        onPressed: () async {
                          if (isEditing[index] && className != editController.text && editController.text != "") {
                            await db.updateClasses(index, editController.text ?? className);
                            snackKey.currentState.showSnackBar(SnackBar(
                              content: Text("Class name changed!"),
                              duration: Duration(seconds: 2)
                            ));
                          }
                          editController.text = "";
                          setState(() {
                            isEditing[index] = !isEditing[index];
                          });
                        }
                      ),
                      onTap: () {
                        setState(() {
                          isEditing.forEach((e) => e = false);
                        });
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) {
                              return ClassActions(uid: uid, className: className, classIndex: index);
                            }
                          )
                        );
                      },
                    )
                  )
                );
              },
              separatorBuilder: (context, index) {
                return Container(height: 12, width: 0);
              },
              )
            ),
            // drawer: DrawerMenu(username: username, role: role, currentPage: PageEnum.driverData),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add, color: white2),
              backgroundColor: green4,
              onPressed: () async {
                String _class = "class";
                String _isEditing = "isEditing";
                String _controller = "controller";
                Map<String, dynamic> newClass = {
                  _class : "",
                  _isEditing : true,
                  _controller : TextEditingController()
                };
                if (newClass != null) {
                  setState(() {
                    // classes.add(newClass);
                    isEditing.add(true);
                  });
                  await db.updateClasses(classes.length, "New Class");
                }
              }
            ),
          );
        } else {
          return Container(height: 10);
        }
      }
    );
  }
}
