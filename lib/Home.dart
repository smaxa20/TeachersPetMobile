import 'package:flutter/material.dart';
import 'Login.dart';
import 'ClassActions.dart';
import 'utilClasses.dart';

class Home extends StatefulWidget {
  Home({Key key, @required this.username}) : super();

  final String username;

  @override
  _HomeState createState() => _HomeState(username: username);
}

class _HomeState extends State<Home> {
  _HomeState({Key key, @required this.username}) : super();

  final String username;

  final newDriverFormKey = GlobalKey<FormState>();
  final snackKey = GlobalKey<ScaffoldState>();

  static final String _class = "class";
  static final String _isEditing = "isEditing";
  static final String _controller = "controller";
  // TODO: get driver data
  final List<Map<String, dynamic>> classes = [
    {
      _class : "First Period",
      _isEditing : false,
      _controller : TextEditingController()
    },
    {
      _class : "Second Period",
      _isEditing : false,
      _controller : TextEditingController()
    },
    {
      _class : "Third Period",
      _isEditing : false,
      _controller : TextEditingController()
    },
    {
      _class : "Fifth Period",
      _isEditing : false,
      _controller : TextEditingController()
    },
    {
      _class : "Sixth Period",
      _isEditing : false,
      _controller : TextEditingController()
    },
  ];

  @override
  Widget build(BuildContext context) {
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
            String className = classes[index][_class];
            bool isEditing = classes[index][_isEditing];
            TextEditingController editController = classes[index][_controller];

            Widget title;
            if (isEditing) {
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
                    text: isEditing ? "Done" : "Edit",
                    color: green2,
                    textColor: Colors.black,
                    smallText: true,
                    width: 60,
                    padding: EdgeInsets.all(0),
                    borderRadius: 20,
                    onPressed: (){
                      if (isEditing && className != editController.text && editController.text != "") {
                        setState(() {
                          classes[index][_class] = editController.text;
                          // TODO: make this change in the database
                        });
                        snackKey.currentState.showSnackBar(SnackBar(
                          content: Text("Class name changed!"),
                          duration: Duration(seconds: 2)
                        ));
                      }
                      editController.text = "";
                      setState(() {
                        classes[index][_isEditing] = !classes[index][_isEditing];
                      });
                    }
                  ),
                  onTap: () {
                    setState(() {
                      classes.forEach((e) => e[_isEditing] = false);
                    });
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) {
                          return ClassActions(username: username, className: className);
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
              classes.add(newClass);
            });
          }
        }
      ),
    );
  }
}
