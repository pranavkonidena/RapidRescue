import 'package:ambulance_app/src/models/ambulance.dart';
import 'package:ambulance_app/src/screens/ambulance_detail.dart';
import 'package:ambulance_app/src/screens/get_help_screen.dart';
import 'package:ambulance_app/src/screens/voice_screen.dart';
import 'package:ambulance_app/src/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_to_text.dart';

class LandingWidget extends StatelessWidget {
  const LandingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Rapid",
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        color: Colors.black87,
                        fontSize: 32,
                        fontWeight: FontWeight.bold)),
              ),
              Text(
                "Rescue",
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        color: Colors.black87,
                        fontSize: 32,
                        fontWeight: FontWeight.normal)),
              ),
            ],
          ),
          LottieBuilder.network(
            "https://lottie.host/442c84bc-3267-4395-b15f-1e2fce5ad04a/H8tmkPoEXm.json",
            //"https://lottie.host/4242344f-6eb9-4aae-88ef-aae7335b97b4/YxSdn6yT2d.json",
            animate: true,
            height: 200,
          ),
          SizedBox(
            height: 40,
          ),
          SizedBox(
            height: 76,
            child: ElevatedButton(
                onPressed: () async {
                  // Position position = await getCurrentLoc();
                  // // Ambulance ambulance =
                  // //     await getAssignedAmbulance(position.latitude , position.longitude);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>
                  //             AmbulanceDetail(ambulance: Ambulance(1, "1", "1.1", "11"))));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SpeechToTextPage()));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(219, 0, 0, 0.9),
                    fixedSize: Size.fromWidth(295),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: Text(
                  "Call an Ambulance",
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600)),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "OR",
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.13),
                      fontSize: 24,
                      fontWeight: FontWeight.normal)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GetHelpScreen()));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
                fixedSize: const Size.fromHeight(76),
                shape: RoundedRectangleBorder(
                    side:
                        const BorderSide(color: Color.fromRGBO(219, 0, 0, 0.9)),
                    borderRadius: BorderRadius.circular(10))),
            child: Text("Call Emergency Contacts",
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        color: Color.fromRGBO(219, 0, 0, 0.9),
                        fontSize: 19,
                        fontWeight: FontWeight.w500))),
          )
        ],
      ),
    );
  }
}
