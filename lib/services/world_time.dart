import 'dart:convert';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class WorldTime {

  String location;
  String time;
  String url;

  bool isDaytime;

  WorldTime({
    this.location,
    this.url,
  });

  Future<void> getTime() async{

    try {
      Response response = await get('http://worldtimeapi.org/api/timezone/$url');
      Map data = jsonDecode(response.body);

      String datetime = data['datetime'];
      String offset = data['utc_offset'].substring(1,3);

      DateTime current = DateTime.parse(datetime);
      current = current.add(Duration(hours: int.parse(offset)));

      isDaytime = current.hour > 6 && current.hour < 18 ? true : false;
      time = DateFormat.jm().format(current);
    }

    catch (e) {
      time = 'Time data not found';
    }
  }
}