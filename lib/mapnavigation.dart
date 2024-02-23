import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
class maps extends StatefulWidget {
  const maps({super.key});

  @override
  State<maps> createState() => _mapsState();
}

class _mapsState extends State<maps> {
  Future<void> _launchGoogleMapsDirections(double endLatitude, double endLongitude) async {
    LocationData currentLocation = await Location().getLocation();
    final String googleMapsUrl = "https://www.google.com/maps/dir/?api=1&origin=${currentLocation.latitude},${currentLocation.longitude}&destination=$endLatitude,$endLongitude";

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch Google Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: TextButton(
            onPressed: () {
              _launchGoogleMapsDirections( 11.0987654, 79.2437767); // Replace with your starting and ending latitude and longitude
            },
            child: Text('Get Directions'),
          )

      )
      ,
    );
  }
}
