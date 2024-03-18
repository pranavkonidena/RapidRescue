import 'dart:convert';

import 'package:latlong2/latlong.dart';

class Ambulance {
  int timeOfArrival;
  String numberPlate;
  String current_location_latitude;
  String current_location_longitude;
  List<LatLng> route;

  Ambulance(
      this.timeOfArrival,
      this.numberPlate,
      this.current_location_latitude,
      this.current_location_longitude,
      this.route);
}

Ambulance fromJson(dynamic result) {
  dynamic temp = jsonDecode(result);
  dynamic data = temp["data"];
  List<dynamic> temper = jsonDecode(temp["waypoints"])["coordinates"];
  List<LatLng> route = [];
  for (int i = 0; i < temper.length; i++) {
    route.add(LatLng(temper[i][1], temper[i][0]));
  }
  Ambulance ambulance = Ambulance(
      temp["time"],
      data["number_plate"],
      data["current_location_latitude"],
      data["current_location_longitude"],
      route);

  return ambulance;
}

