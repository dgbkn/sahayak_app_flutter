import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mediaquery_sizer/mediaquery_sizer.dart';
import 'package:sahayak/pages/Dashboard.dart';
import 'package:sahayak/utils.dart';

class SOS_Page extends StatefulWidget {
  const SOS_Page({super.key});

  @override
  State<SOS_Page> createState() => _SOS_PageState();
}

class _SOS_PageState extends State<SOS_Page> {

    void loadNextPage() {
    Timer(const Duration(seconds: 4), () {
      //api call to sos 
      showSnackBar("SOS Sent", "Success", ContentType.success, context);
      changePageTo(context, Dashboard(),replace: true);
    });
  }

  void initState() {
    super.initState();
    loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(children: [
        SizedBox(
          height: 5.h(context),
        ),
        Center(
            child: Text(
          "Sending a SOS beacon to nearby \n Hospitals for Faster Preparation.",
          style: GoogleFonts.poppins(
              fontSize: 18.sp(context), fontWeight: FontWeight.w600),
        )),
        Lottie.asset("assets/sos_speaker.json", height: 40.h(context))
      ]),
    ));
  }
}
