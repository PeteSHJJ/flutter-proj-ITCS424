import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  final double lat;
  final double lng;
  final String name;
  final String url;
  final String address;
  final String phoneNumber;

  const MapsPage(
      {Key? key,
      required this.lat,
      required this.lng,
      required this.name,
      required this.url,
      required this.address,
      required this.phoneNumber})
      : super(key: key);
  _MapsPage createState() => _MapsPage();
}

class _MapsPage extends State<MapsPage> {
  late double lat1 = widget.lat, lng1 = widget.lng;
  late String HospitalName = widget.name;
  late String url = widget.url;
  late String phoneNumber = widget.phoneNumber;
  late String address = widget.address;
  // late String address =
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[900],
          centerTitle: true,
          title: const Text(
            'Map',
          ),
        ),
        body: Column(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(HospitalName),
              ),
            ),
            Container(
              margin: EdgeInsets.all(16.0),
              width: 150.0,
              height: 150.0,
              child: Image.network(
                url,
                fit: BoxFit.cover,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(address),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text(phoneNumber),
            ),
            showMap(),
          ],
        ));
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

    Marker userMarker() {
      return Marker(
        markerId: const MarkerId('userMarker'),
        position: LatLng(userLocation!.latitude, userLocation!.longitude),
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
      child: lat1 == null && userLocation!.latitude == null
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
