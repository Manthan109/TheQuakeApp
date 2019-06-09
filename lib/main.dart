import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Map _quakes;

void main() async {
  _quakes = await getQuake();
  runApp(MaterialApp(
    home: new Home(),
  ));
}

Future<Map> getQuake() async {
  String apiURL =
      "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/4.5_week.geojson";
  http.Response _response = await http.get(apiURL);
  return json.decode(_response.body);
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Quake",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23.5,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          if (index.isEven)
            return Divider(
              height: 12.0,
            );
          var format = new DateFormat.yMMMMd("en_US").add_jm();

          var date = format.format(DateTime.fromMillisecondsSinceEpoch(
              _quakes["features"][index]["properties"]["time"],
              isUtc: true));
          return ListTile(
            title: Text(
              "$date",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                  fontSize: 19.4),
            ),
            subtitle: Text(
              "${_quakes["features"][index]["properties"]["place"]}",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
            leading: CircleAvatar(
              child: Text(
                "${_quakes["features"][index]["properties"]["mag"]}",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              backgroundColor: Colors.blue,
            ),
            onTap: () => _showTapMessage(context,
                "${_quakes["features"][index]["properties"]["place"]}"),
          );
        },
        itemCount: _quakes["features"].length,
      ),
    );
  }
}

void _showTapMessage(BuildContext context, String message) {
  var _alert = AlertDialog(
    title: Text(
      "Region",
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 25.7, color: Colors.red),
    ),
    
    content: Text(
      message,
      style: TextStyle(fontStyle: FontStyle.normal),
    ),
    actions: <Widget>[
      FlatButton(
        child: Text("Ok"),
        onPressed: () => Navigator.of(context).pop(),
      )
    ],
  );
  showDialog(
      context: context,
      builder: (context) {
        return _alert;
      });
}
