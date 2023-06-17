import 'dart:convert';

import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:mediaquery_sizer/mediaquery_sizer.dart';
import 'package:sahayak/pages/Hospitals.dart';
import 'package:sahayak/pages/LoginPage.dart';
import 'package:sahayak/pages/SOS_Page.dart';
import 'package:sahayak/utils.dart';

var boxLogin = Hive.box("stats");

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var name = "";

  Future getName() async {
    // var details = {"no": box.get("phoneNo"), "otp": otp};

    final response = await get(
      Uri.parse(
          'https://ccs-internal-hack-1.pushanagrawal.repl.co/userdata?token=' +
              box.get("token")),
    );

    if (response.statusCode == 200) {
      var d = jsonDecode(response.body);
      print(d);
      var name_ = d["name"];
      setState(() {
        name = name_;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getName();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 3.h(context),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 5.w(context),
                      ),
                      Text(
                        "Welcome",
                        style: GoogleFonts.poppins(fontSize: 20.sp(context)),
                      ),
                      SizedBox(
                        width: 1.w(context),
                      ),
                      name != ""
                          ? Text(
                              name,
                              style: GoogleFonts.poppins(
                                  fontSize: 20.sp(context),
                                  fontWeight: FontWeight.w600),
                            )
                          : CircularProgressIndicator(),
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        EasyDynamicTheme.of(context).changeTheme(
                            dark: Theme.of(context).brightness !=
                                Brightness.dark);
                      },
                      icon: Icon(Theme.of(context).brightness == Brightness.dark
                          ? Icons.dark_mode
                          : Icons.light_mode)),
                  IconButton(
                      onPressed: () {
                       boxLogin.delete("token");
                       changePageTo(context, LoginPage(),replace: true);
                      },
                      icon: Icon(Icons.logout))
                ],
              ),
            ),
            SizedBox(
              height: 3.h(context),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.w(context)),
                child: Image.asset(
                  "assets/corona_people.jpg",
                  width: 100.w(context),
                  height: 32.h(context),
                ),
              ),
            ),
            SizedBox(
              height: 2.h(context),
            ),
            Center(
                child: Row(children: [
              SizedBox(
                width: 7.w(context),
              ),
              Text(
                "Emergency Panel",
                style: GoogleFonts.poppins(
                    fontSize: 20.sp(context), fontWeight: FontWeight.w500),
              ),
            ])),
            SizedBox(
              height: 2.h(context),
            ),
            Row(
              children: [
                SizedBox(
                  width: 7.w(context),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(210, 219, 19, 9)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  onPressed: () {
                    changePageTo(context, SOS_Page());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "SOS",
                      style: GoogleFonts.poppins(
                          fontSize: 20.sp(context),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(
                  width: 2.w(context),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.green[800]),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  onPressed: () {
                    changePageTo(context, Hospitals());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Hospitals",
                      style: GoogleFonts.poppins(
                          fontSize: 20.sp(context),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 2.h(context),
            ),
            Center(
                child: Row(children: [
              SizedBox(
                width: 7.w(context),
              ),
              Text(
                "Health Tips",
                style: GoogleFonts.poppins(
                    fontSize: 20.sp(context), fontWeight: FontWeight.w500),
              ),
            ])),
            SizedBox(
              height: 2.h(context),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Color.fromARGB(255, 173, 142, 2)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: 70.w(context),
                  child: Row(
                    children: [
                      Icon(Icons.healing),
                      SizedBox(
                        width: 2.h(context),
                      ),
                      Text(
                        "How to protect yourself\n & other from covid",
                        style: GoogleFonts.poppins(
                            fontSize: 13.sp(context),
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 1.h(context),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green[700]),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: 70.w(context),
                  child: Row(
                    children: [
                      Icon(Icons.monetization_on),
                      SizedBox(
                        width: 2.h(context),
                      ),
                      Text(
                        "Affordable and healthy eating\ntips for bp/sugar patient",
                        style: GoogleFonts.poppins(
                            fontSize: 13.sp(context),
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
