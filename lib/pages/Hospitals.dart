import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sahayak/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Hospitals extends StatefulWidget {
  const Hospitals({super.key});

  @override
  State<Hospitals> createState() => _HospitalsState();
}

class _HospitalsState extends State<Hospitals> {
  late GoogleMapController mapController;
  bool display = false;

  late LatLng _currentPosition;

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

    LatLng location = LatLng(lat, long);

    setState(() {
      _currentPosition = location;
      display = true;
    });
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Hospitals"),
        centerTitle: true,
      ),
      body: display
          ? GoogleMap(
              onMapCreated: _onMapCreated,
              // circles: Set.from([
              //   Circle(
              //     circleId: CircleId("My Location"),
              //     center: _currentPosition,
              //     radius: 10,
              //   )
              // ]),
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 16.0,
              )
              
              )
          : SizedBox(),
    ));
  }
}
