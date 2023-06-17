import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:mediaquery_sizer/mediaquery_sizer.dart';
import 'package:sahayak/utils.dart';

// import 'package:google_maps_flutter/google_maps_flutter.dart';

class Hospitals extends StatefulWidget {
  const Hospitals({super.key});

  @override
  State<Hospitals> createState() => _HospitalsState();
}

class _HospitalsState extends State<Hospitals> {
  bool display = false;
  String locName = "";
  double latitude = 0;
  double longitude = 0;

  List<Container> hospitals = [];

  Future getTheHospitals(lat, long) async {
    // var details = {"no": box.get("phoneNo"), "otp": otp};

    final response = await get(
      Uri.parse(
          'https://ccs-internal-hack-1.pushanagrawal.repl.co/apis?token=' +
              box.get("token") +
              "&lat=$lat&lon=$long"),
    );

    if (response.statusCode == 200) {
      // print(response.body);
      var d = jsonDecode(response.body);
      d["hospitals"].forEach((ele) {
        var name = ele[0];
        var lat = ele[1][0];
        var long = ele[1][1];
        var time = ele[2];
        var dist = ele[3];
        var id = ele[4];
        var beds = ele[5];
        hospitals
            .add(returnCardHospital(name, lat, long, time, dist, id, beds));
        // print(ele);
        setState(() {});
      });
      setState(() {});
    }
  }

  Container returnCardHospital(name, lat, long, time, dist, id, beds) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  name,
                  style: GoogleFonts.poppins(
                      fontSize: 18.sp(context), fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  "Time To Reach:" +
                      double.parse((time / 60).toStringAsFixed(2)).toString() +
                      " minutes",
                  style: GoogleFonts.poppins(fontSize: 15.sp(context)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  "Distance:" +
                      double.parse((dist / 1000).toStringAsFixed(2))
                          .toString() +
                      " km",
                  style: GoogleFonts.roboto(fontSize: 15.sp(context)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  "No. of Beds:$beds",
                  style: GoogleFonts.roboto(fontSize: 15.sp(context)),
                ),
              ),
              SizedBox(
                height: 2.h(context),
              )
            ]),
          ),
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showSnackBar(
          'Location services are disabled.', '', ContentType.failure, context);
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showSnackBar('Location permissions are denied', '', ContentType.failure,
            context);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showSnackBar(
          'Location permissions are permanently denied, we cannot request permissions.',
          '',
          ContentType.failure,
          context);

      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      print("LOCATION REQUEST GRANTED;");
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void getLocation() async {
    print("START");
    Position position = await _determinePosition();
    double lat = position.latitude;
    double long = position.longitude;

    // LatLng location = LatLng(lat, long);

    final response_loc = await get(
      Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=AIzaSyBOti4mM-6x9WDnZIjIeyEU21OpBXqWBgw'),
    );

    var loc = jsonDecode(response_loc.body);

    setState(() {
      latitude = lat;
      longitude = long;
      display = true;
      locName = loc["results"][0]["formatted_address"];
    });

    getTheHospitals(lat, long);
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  // void _onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Hospitals"),
        centerTitle: true,
      ),
      body: display
          ?
          // ? GoogleMap(
          //     onMapCreated: _onMapCreated,
          //     // circles: Set.from([
          //     //   Circle(
          //     //     circleId: CircleId("My Location"),
          //     //     center: _currentPosition,
          //     //     radius: 10,
          //     //   )
          //     // ]),
          //     initialCameraPosition: CameraPosition(
          //       target: _currentPosition,
          //       zoom: 16.0,
          //     )
          SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 2.h(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text("Your Location is $locName")),
                  ),
                  hospitals.isEmpty
                      ? Column(
                          children: [
                            SizedBox(
                              height: 3.h(context),
                            ),
                            CircularProgressIndicator(),
                          ],
                        )
                      : Column(
                          children: hospitals,
                        ),
                ],
              ),
            )
          : SizedBox(),
    ));
  }
}
