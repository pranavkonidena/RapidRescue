import 'dart:async';

import 'package:ambulance_app/src/models/ambulance.dart';
import 'package:ambulance_app/src/models/return_api.dart';
import 'package:ambulance_app/src/screens/ambulance_detail.dart';
import 'package:ambulance_app/src/services/api_service.dart';
import 'package:ambulance_app/src/state/blurb_stream.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextPage extends StatefulWidget {
  const SpeechToTextPage({Key? key}) : super(key: key);

  @override
  _SpeechToTextPage createState() => _SpeechToTextPage();
}

class _SpeechToTextPage extends State<SpeechToTextPage> {
  final TextEditingController _textController = TextEditingController();

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = "";
  bool pressed = false;

  void listenForPermissions() async {
    final status = await Permission.microphone.status;
    switch (status) {
      case PermissionStatus.denied:
        requestForPermission();
        break;
      case PermissionStatus.granted:
        break;
      case PermissionStatus.limited:
        break;
      case PermissionStatus.permanentlyDenied:
        break;
      case PermissionStatus.restricted:
        break;
      case PermissionStatus.values:
        break;
      case PermissionStatus.provisional:
        break;
    }
  }

  Future<void> requestForPermission() async {
    await Permission.microphone.request();
  }

  @override
  void initState() {
    super.initState();
    listenForPermissions();
    if (!_speechEnabled) {
      _initSpeech();
    }
    
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 60),
      localeId: "en_En",
      cancelOnError: false,
      partialResults: false,
      listenMode: ListenMode.confirmation,
    );
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    print("A");
    await _speechToText.stop();
    setState(() {});
    await Future.delayed(Duration(seconds: 1));
    print(_lastWords);
    if (_lastWords != "") {
      Position position = await getCurrentLoc();
      Ambulance ambulance =
          await getAssignedAmbulance(position.latitude, position.longitude);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AmbulanceDetail(ambulance: ambulance)));
      List<dynamic> result = await getBlurb(_lastWords);
      BlurbStream.blurbStream.indexSink.add(result);
      _textController.text = "";
      _lastWords = "";
    } else {}
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = "$_lastWords${result.recognizedWords} ";
      _textController.text = _lastWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1000,
        width: 1000,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(219, 0, 0, 0.9),
            Color.fromARGB(228, 101, 1, 1),
          ],
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 150,
            ),
            RippleAnimation(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    pressed = true;
                  });
                  _speechToText.isNotListening
                      ? _startListening()
                      : _stopListening();
                },
                child: Icon(
                  _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
                  size: 60,
                  color: Color.fromRGBO(221, 25, 25, 1),
                ),
                style: ElevatedButton.styleFrom(
                    shape: CircleBorder(), fixedSize: Size.fromRadius(60)),
              ),
              color: Color.fromRGBO(255, 255, 255, 0.18),
              delay: const Duration(milliseconds: 300),
              repeat: !pressed,
              minRadius: 75,
              ripplesCount: 6,
              duration: const Duration(milliseconds: 6 * 300),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, bottom: 100),
              child: Text(
                "Please describe what has happened?",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
