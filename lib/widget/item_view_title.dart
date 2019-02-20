import 'package:flutter/material.dart';

class TitleView extends StatefulWidget {
  final String title;

  TitleView(this.title);

  @override
  State<StatefulWidget> createState() {
    return _TitleState();
  }
}

class _TitleState extends State<TitleView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 0.0, color: Colors.black26))),
      child: Row(
        children: <Widget>[
          Container(
            width: 5,
            height: 50,
            color: Colors.blue,
          ),
          Container(
              margin: EdgeInsets.only(
                  left: 20.0, top: 10.0, right: 0, bottom: 10.0),
              child: Text(widget.title,
                  style: TextStyle(color: Colors.black87, fontSize: 16.0))),
        ],
      ),
    );
  }
}
