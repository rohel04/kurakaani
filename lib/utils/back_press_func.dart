import 'package:flutter/material.dart';

class BackPress {
  static Future<bool> onBackPressed(context) async {
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: new Text('Are you sure?'),
              content: new Text('Do you want to exit an App'),
              actions: <Widget>[
                new GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "No",
                        style: TextStyle(fontSize: 16),
                      )),
                ),
                SizedBox(height: 16),
                new GestureDetector(
                    onTap: () => Navigator.of(context).pop(true),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Yes",
                        style: TextStyle(fontSize: 16),
                      ),
                    )),
              ],
            ));
  }

}
