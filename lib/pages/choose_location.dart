import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:world_time/services/world_time.dart';

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {

  List<WorldTime> timezone = [];

  Future<List<WorldTime>> fetch() async{
    var url = "http://worldtimeapi.org/api/timezone";
    var worldResponse = await http.get(url);

    var jsonData = json.decode(worldResponse.body);

    List<WorldTime> locations = [];
    for(var data in jsonData) {
      locations.add(WorldTime(location: data, url: data));
    }
    return locations;
  }

  void updateTime(index) async {
    WorldTime instance = timezone[index];
    await instance.getTime();

    Navigator.pop(context, {
      'location': instance.location,
      'time': instance.time,
      'isDaytime' : instance.isDaytime,
    });
  }

  Widget getBody() {
    return Container(
      child: FutureBuilder(
        future: fetch(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return ListView.builder(
              itemCount: 0,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      onTap: () {
                        updateTime(index);
                      },
                      title: Text(timezone[index].location),
                    ),
                  ),
                );
              }
          );
        }
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Choose a Location'),
        centerTitle: true,
        elevation: 0,
      ),
      body: getBody(),
    );
  }
}
