import 'dart:async';
import 'dart:convert';

import 'package:ambulance_app/src/models/ambulance.dart';
import 'package:ambulance_app/src/models/return_api.dart';
import 'package:ambulance_app/src/screens/map.dart';
import 'package:ambulance_app/src/services/api_service.dart';
import 'package:ambulance_app/src/state/blurb_stream.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AmbulanceDetail extends StatefulWidget {
  AmbulanceDetail({super.key, required this.ambulance});
  Ambulance ambulance;

  @override
  State<AmbulanceDetail> createState() => _AmbulanceDetailState();
}

class _AmbulanceDetailState extends State<AmbulanceDetail> {
  final _sheet = GlobalKey();
  final _controller = DraggableScrollableController();
  late WebViewController controller;
  int currentTime = 0;

  @override
  void initState() {
    Timer time = Timer.periodic(Duration(seconds: 30), (timer) async {
      ReturnModel current = await getCurrentLocationOfAmbulance();
      setState(() {
        currentTime = current.time;
      });
     });
    super.initState();
    _controller.addListener(_onChanged);
  }

  void _onChanged() {
    final currentSize = _controller.size;
    if (currentSize <= 0.05) _collapse();
  }

  void _collapse() => _animateSheet(sheet.snapSizes!.first);

  void _anchor() => _animateSheet(sheet.snapSizes!.last);

  void _expand() => _animateSheet(sheet.maxChildSize);

  void _hide() => _animateSheet(sheet.minChildSize);

  void _animateSheet(double size) {
    _controller.animateTo(
      size,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
  }

  DraggableScrollableSheet get sheet =>
      (_sheet.currentWidget as DraggableScrollableSheet);

  BlurbStream _blurbStream = BlurbStream();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Details of Your Ambulance"),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            MapWidget(ambulance: widget.ambulance,),
            DraggableScrollableSheet(
              initialChildSize: 0.3,
              minChildSize: 0.3,
              maxChildSize: 0.85,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                    controller: scrollController,
                    child: Container(
                      color: Colors.white,
                      height: 600,
                      width: 1000,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                                left: 150.0, right: 150, top: 20),
                            child: Divider(
                              color: Color.fromRGBO(0, 0, 0, 0.17),
                              thickness: 4,
                              height: 4,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 200,
                            width: 1000,
                            child: Container(
                                color: Color.fromRGBO(0, 229, 105, 1),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image.asset("assets/man.png"),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 14.0),
                                          child:  currentTime == 0 ?    Text(
                                            widget.ambulance.timeOfArrival
                                                    .toString() +
                                                " mins away ",
                                            style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ) :  Text(
                                            currentTime.toString() +
                                                " mins away ",
                                            style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 28.0),
                                          child: Text(
                                            widget.ambulance.numberPlate,
                                            style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        69, 69, 69, 0.81),
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                        ),
                                        // SizedBox(
                                        //   height: 200,
                                        // )
                                      ],
                                    )
                                  ],
                                )),
                          ),
                          StreamBuilder(
                            stream:
                                _blurbStream.indexStream.asBroadcastStream(),
                            builder: (context, snapshot) {
                              if (snapshot.data == null) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(
                                        "Emergency Services are on their way \nKeep calm.",
                                        style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 24,
                                                fontWeight: FontWeight.w600)), textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Center(
                                      child: Image.asset(
                                        "assets/danger.png",
                                        height: 50,
                                        width: 50,
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                          "Stay Alert For Further Instructions",
                                          style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      221, 25, 25, 1),
                                                  fontSize: 24,
                                                  fontWeight:
                                                      FontWeight.w600)) , textAlign: TextAlign.center,),
                                    )
                                  ],
                                );
                              } else {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    if (!snapshot.data![index]
                                        .toString()
                                        .contains("youtu")) if (index != 0) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                            snapshot.data![index].toString()),
                                      );
                                    } else {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                            "According to your call, please follow these instructions! \n ${snapshot.data![index]}"),
                                      );
                                    }
                                    else {
                                      controller = WebViewController()
                                        ..enableZoom(true)
                                        ..setJavaScriptMode(
                                            JavaScriptMode.unrestricted)
                                        ..loadRequest(
                                            Uri.parse(snapshot.data![index]));
                                    }
                                    return SizedBox(
                                      height: 200,
                                      child:
                                          WebViewWidget(controller: controller),
                                    );
                                  },
                                );
                              }
                            },
                          )
                        ],
                      ),
                    ));
              },
            )
          ],
        ));
  }
}
