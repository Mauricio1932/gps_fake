import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trust_location/trust_location.dart';

class StrustLocation extends StatefulWidget {
  const StrustLocation({Key? key}) : super(key: key);

  @override
  State<StrustLocation> createState() => _StrustLocationState();
}

class _StrustLocationState extends State<StrustLocation> {
  String? latitude;
  String? logitude;
  bool? isMock;
  bool showText = false;
  bool controlador = false;

  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  void requestPermission() async {
    final permission = await Permission.location.request();

    if (permission == PermissionStatus.granted) {
      controlador = true;
    } else if (permission == PermissionStatus.denied) {
      await Permission.location.request();
    }
  }

  void getLocation() async {
    try {
      TrustLocation.onChange.listen((result) {
        setState(() {
          latitude = result.latitude;
          logitude = result.longitude;
          isMock = result.isMockLocation;
          showText = true;
        });
        geoCode();
      });
    } catch (e) {
      print('ERROR');
    }
  }

  void geoCode() async {
    List<Placemark> placemark = await placemarkFromCoordinates(
        double.parse(latitude!), double.parse(logitude!));
    print(placemark[0].country);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trust Location'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              child: const Text(
                'Geolocalizador',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blueAccent,
              shape: const StadiumBorder(),
              elevation: 0,
              splashColor: Colors.transparent,
              onPressed: () {
                _getCurrentLocation();
              },
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: FutureBuilder(
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (isMock == false) return _texto3();
                  return _texto2();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  _getCurrentLocation() async {
    if (controlador == true) {
      TrustLocation.start(10);
      getLocation();
    }
  }

  Text _texto() {
    return Text(showText
        ? "Latitud: $latitude, Longitude: $logitude, ISMOKE: $isMock"
        : "");
  }

  Text _texto2() {
    return Text(showText ? "ESTA UTILIZANDO GPS FAKE" : "");
  }

  Text _texto3() {
    return Text(showText ? "ESTA UTILIZANDO GPS REAL" : "");
  }
}
