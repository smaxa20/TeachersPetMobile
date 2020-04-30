import 'package:flutter/material.dart';

Color white1 = Color.fromRGBO(238, 239, 235, 1);
Color white2 = Color.fromRGBO(223, 230, 217, 1);
Color green1 = Color.fromRGBO(217, 223, 198, 1);
Color green2 = Color.fromRGBO(184, 204, 175, 1);
Color green3 = Color.fromRGBO(130, 165, 134, 1);
Color green4 = Color.fromRGBO(67, 98, 82, 1);

enum Role {client, driver, admin, dispatch}
enum PageEnum {admin, boxOwner, driver, driverData, messaging, requests}


class FilledInput  extends StatelessWidget{
  FilledInput({
    Key key,
    @required this.hintText,
    this.smallText = false,
    this.maxLines = 1,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.controller,
    this.obscureText = false,
    this.validation
  }) : super(key: key);

  final String hintText;
  final bool smallText;
  final int maxLines;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final TextEditingController controller;
  final bool obscureText;
  final Function validation;
  
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle;
    EdgeInsets padding;
    if (smallText) {
      textStyle = TextStyle(fontFamily: "Times New Roman", fontSize: 16);
      padding = EdgeInsets.all(12);
    } else {
      textStyle = TextStyle(fontFamily: "Times New Roman", fontSize: 24);
      padding = EdgeInsets.all(16);
    }

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      autofocus: autofocus,
      textCapitalization: textCapitalization,
      textInputAction: TextInputAction.done,
      style: textStyle,
      obscureText: obscureText,
      validator: validation,
      decoration: InputDecoration(
        contentPadding: padding,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        hintText: hintText,
        hintStyle: textStyle,
        errorStyle: TextStyle(fontFamily: "Times New Roman", fontSize: 16),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red, 
            width: 3
          ), 
          borderRadius: BorderRadius.all(Radius.circular(5))
        )
      ),
    );
  }
}

class TransparentButton extends StatelessWidget {
  TransparentButton({Key key, @required this.text, @required this.color, @required this.onTap}) : super(key: key);

  final String text;
  final Color color;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontFamily: "Times New Roman",
          fontSize: 25,
          decoration: TextDecoration.underline
        )
      )
    );
  }
}

class FilledButton extends StatelessWidget {
  FilledButton({
    Key key,
    @required this.text,
    @required this.color,
    @required this.onPressed,
    this.textColor = Colors.black,
    this.borderRadius = 5,
    this.height = 36.0,
    this.width = 88.0,
    this.padding,
    this.smallText = false
  }) : super(key: key);

  final String text;
  final Color color;
  final Function onPressed;
  final Color textColor;
  final double borderRadius;
  final double height;
  final double width;
  final EdgeInsets padding;
  final bool smallText;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: height,
      minWidth: width,
      child: RaisedButton(
        padding: padding,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
        color: color,
        child: Text(
          text,
          style: TextStyle(color: textColor, fontFamily: "Times New Roman", fontSize: smallText ? 16 : 24)
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class PercentageContainer extends StatelessWidget {
  PercentageContainer({Key key, @required this.percentage}) : super(key: key);

  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(height: MediaQuery.of(context).size.height * percentage, width: 0)
    );
  }
}