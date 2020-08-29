import 'package:flutter/material.dart';

AppBar header(context,
    {bool isAppTitle = false,
    String srtTittle,
    disappearedBackButton = false}) {
  return AppBar(
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    automaticallyImplyLeading: disappearedBackButton ? true : false,
    title: Text(
      isAppTitle ? "Cuchito" : srtTittle,
      style: TextStyle(
        color: Colors.white,
        fontFamily: isAppTitle ? "Billabong" : "",
        fontSize: isAppTitle ? 58.0 : 22.0,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}
