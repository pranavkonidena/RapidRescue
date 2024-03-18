import 'dart:async';

import 'package:ambulance_app/src/models/ambulance.dart';
import 'package:ambulance_app/src/models/return_api.dart';
import 'package:ambulance_app/src/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatefulWidget {
  MapWidget({super.key , required this.ambulance});
  Ambulance ambulance;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late Position currentPosition;
  double currentLat = 0;
  double currentLang = 0;
  late int currentTime;
  bool posFetched = false;
  @override
  void initState() {
    // TODO: implement initState
    getCurrentLoc().then((value) => setState(() {
          currentPosition = value;
          posFetched = true;
        }));
    super.initState();
    Timer time = Timer.periodic(Duration(seconds: 10), (timer) async {
      ReturnModel current = await getCurrentLocationOfAmbulance();
      setState(() {
        currentLat = current.position.latitude;
        currentLang = current.position.longitude;
        currentTime = current.time;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(currentLat);
    return SizedBox(
      height: 500,
      width: 1000,
      child: Stack(
        children: [
          posFetched
              ? FlutterMap(
                  options: MapOptions(
                      initialCenter: LatLng(
                          currentPosition.latitude, currentPosition.longitude),
                      initialZoom: 15),
                  children: [
                      TileLayer(
                        urlTemplate:
                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        userAgentPackageName: "com.example.app",
                      ),
                      PolylineLayer(
                        polylines: [
                          Polyline(points: widget.ambulance.route, color: Colors.blue, strokeWidth: 4),
                        ],
                      ),
                      MarkerLayer(markers: [
                        Marker(
                            point: LatLng(currentLat, currentLang),
                            child: Image.asset("assets/get_help.png")),
                      ])
                    ])
              : const Center(child: CircularProgressIndicator())
        ],
      ),
    );
  }
}
