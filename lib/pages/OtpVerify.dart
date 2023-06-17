import 'dart:convert';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:mediaquery_sizer/mediaquery_sizer.dart';
import 'package:pinput/pinput.dart';
import 'package:sahayak/pages/Dashboard.dart';
import 'package:sahayak/utils.dart';


var boxLogin = Hive.box("stats");

class OtpVerify extends StatefulWidget {
  const OtpVerify({super.key});

  @override
  State<OtpVerify> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  void handleOtp(value) async {
    if (value.isEmpty) {
      showSnackBar("Enter OTP", "Empty input", ContentType.failure, context);
    } else {
      // showSnackBar("OTP:" + value, "Empty input", ContentType.success, context);
      checkOtp(value);
    }
  }

  Future checkOtp(otp) async {
    // var details = {"no": box.get("phoneNo"), "otp": otp};

    final response = await get(
      Uri.parse('https://ccs-internal-hack-1.pushanagrawal.repl.co/otp?no='+box.get("phoneNo")+"&otp="+otp),
    );

    if (response.statusCode == 200) {

      var d = jsonDecode(response.body);
      showSnackBar("Login Success", "", ContentType.success, context);
      var token = d["access_token"];
      print(response.body);

      boxLogin.put("token", token);
      changePageTo(context, Dashboard(),replace: true);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      // var d = jsonDecode(response.body);
      showSnackBar(
          "Login Error", "OTP is Invalid", ContentType.failure, context);
      print(response.body);
    }
  }

  final pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Column(children: [
      SizedBox(
        height: 3.h(context),
      ),
      getSwitcher(context, 0.115),
      SizedBox(
        height: 3.h(context),
      ),
      Lottie.asset(
        'assets/otp_anim.json',
        height: 35.h(context),
      ),
      SizedBox(
        height: 5.h(context),
      ),
      Center(
          child: Text(
        "Enter OTP",
        style: GoogleFonts.poppins(
            fontSize: 20.sp(context), fontWeight: FontWeight.w600),
      )),
      SizedBox(
        height: 3.h(context),
      ),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w(context)),
          child: Pinput(
            androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
            autofocus: true,
            length: 6,
            controller: pinController,
            onSubmitted: (value) {
              handleOtp(value);
            },
            onCompleted: (value) {
              handleOtp(value);
            },

            // controller: pinController,
          )),
    ])));
  }
}
