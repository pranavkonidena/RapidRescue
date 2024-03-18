import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GetHelpScreen extends StatefulWidget {
  const GetHelpScreen({super.key});

  @override
  State<GetHelpScreen> createState() => _GetHelpScreenState();
}

class _GetHelpScreenState extends State<GetHelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Get Help" , style: GoogleFonts.poppins(
            textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w500)
          ),),
          // Image.network(
          //     "https://github-production-user-asset-6210df.s3.amazonaws.com/122373207/311483734-e5b2f73b-2a6f-44aa-8eae-7f55c2473c05.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAVCODYLSA53PQK4ZA%2F20240310%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20240310T043924Z&X-Amz-Expires=300&X-Amz-Signature=626b6fc881ac073038b7dc6db1387737ae8c5e54941bc57a45e10650ed896318&X-Amz-SignedHeaders=host&actor_id=122373207&key_id=0&repo_id=697645000" , height: 77, width: 77,),
          Image.asset("assets/get_help.png" , height: 77, width: 77,),
          Text("Number Of People" , style: GoogleFonts.poppins(
            textStyle: const TextStyle(
                        color: Colors.black, 
                        fontSize: 20,
                        fontWeight: FontWeight.w500)
          ),),
          Text("Send Alerts To" , style: GoogleFonts.poppins(
            textStyle: const TextStyle(
                        color: Colors.black, 
                        fontSize: 18,
                        fontWeight: FontWeight.w500)
          ),)
        ],
      ),
    );
  }
}

