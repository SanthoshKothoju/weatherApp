import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Location extends ChangeNotifier {
 late double latitude;
 late double longitude;

  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        print("location services are disabled");
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        // return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return Future.error('Location permissions are denied');
        }
      }

      Position position = await Geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print("lat ${position.latitude}");

      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      print(e);
    }
  }
}