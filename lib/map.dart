import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  final double lat;
  final double lng;
  final String name;
  const MapsPage(
      {Key? key, required this.lat, required this.lng, required this.name})
      : super(key: key);
  _MapsPage createState() => _MapsPage();
}

class _MapsPage extends State<MapsPage> {
  late double lat1 = widget.lat, lng1 = widget.lng;
  late String HospitalName = widget.name;
  late CameraPosition position;

  Position? userLocation;

  Future<Position?> _getLocation() async {
    try {
      userLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      userLocation = null;
    }
    return userLocation;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: const Text(
          'Map',
        ),
      ),
      body: showMap(),
    );
  }
  //Your code here

  Container showMap() {
    if (lat1 != null) {
      LatLng latLng1 = LatLng(lat1, lng1);
      position = CameraPosition(
        target: latLng1,
        zoom: 16.0,
      );
    }

    Marker hospitalMarker() {
      return Marker(
        markerId: const MarkerId('hospitalMarker'),
        position: LatLng(lat1, lng1),
        icon: BitmapDescriptor.defaultMarkerWithHue(60.0),
        infoWindow: InfoWindow(title: HospitalName),
      );
    }

   

    Set<Marker> mySet() {
      return <Marker>[hospitalMarker()].toSet();
    }

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 32),
      // color: Colors.grey,
      height: 250,
      child: lat1 == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: position,
              mapType: MapType.normal,
              onMapCreated: (controller) {},
              markers: mySet(),
            ),
    );
  }
}
