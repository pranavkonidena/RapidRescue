import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:ambulance_app/src/models/ambulance.dart';
import 'package:ambulance_app/src/models/return_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

String baseUrl = "http://192.168.20.13:8000/";
String basengrokUrl = "https://33d8-103-37-201-176.ngrok-free.app/";

Future<Ambulance> getAssignedAmbulance(double locLat, double locLong) async {
  var response = await http.get(Uri.parse(baseUrl +
      "api/assign-ambulance/?assigned_location_latitude=${locLat}&assigned_location_longitude=${locLong}"));
  print(response);
  return fromJson(response.body);
}

Future<List<dynamic>> getBlurb(String transcript) async {
  Map<String, String> postBody = {"transcript": transcript};
  print(postBody);
  try {
    var response = await http.post(
      Uri.parse(basengrokUrl + "predict"),
      body: jsonEncode(postBody),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    List<dynamic> result = jsonDecode(response.body);
    print(result[0]);
    print(result.runtimeType);
    return result;
  } catch (e) {
    print(e);
    return [];
  }
}

Future<Position> getCurrentLoc() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  print(position);
  return position;
}

Future<ReturnModel> getCurrentLocationOfAmbulance() async {
  var response = await http.get(Uri.parse(baseUrl + "api/remaining-time"));
  var temp = jsonDecode(response.body);
  print(temp);
  Position pos = Position(
      latitude: temp["latitude"],
      longitude: temp["longitude"],
      timestamp: DateTime(2222),
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
      accuracy: 0);
  var time = temp["time_left"];
  return ReturnModel(pos, time);
}

