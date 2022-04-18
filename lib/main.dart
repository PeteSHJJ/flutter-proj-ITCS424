import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:final_proj/map.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Hide the debug banner
      color: Colors.blueGrey,
      debugShowCheckedModeBanner: false,
      title: 'We are ready',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _items = [];
  late double lat;
  late double lng;

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/hospital_data.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["items"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        centerTitle: true,
        title: const Text(
          'We are ready',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            ElevatedButton(
              child: const Text('Load Data'),
              onPressed: readJson,
            ),

            // Display the data loaded from sample.json
            _items.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final double tempLng =
                            double.parse(_items[index]["longtitude"]);
                        final double tempLat =
                            double.parse(_items[index]["latitude"]);
                        final String tempName = _items[index]["name"];
                        final String tempUrl = _items[index]["image"];
                        final String tempAddress = _items[index]["address"];
                        final String tempPhoneNumber = _items[index]["phoneNumber"];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MapsPage(
                                          lat: tempLat,
                                          lng: tempLng,
                                          name: tempName,
                                          url: tempUrl,
                                          address: tempAddress,
                                          phoneNumber: tempPhoneNumber,
                                        )));
                          },
                          child: Card(
                            margin: const EdgeInsets.all(10),
                            child: ListTile(
                              title: Text(_items[index]["name"]),
                              subtitle: Text("longtitude: " +
                                  _items[index]["longtitude"] +
                                  " " +
                                  "latitude: " +
                                  _items[index]["latitude"]),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
