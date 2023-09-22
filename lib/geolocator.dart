import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';



class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Position _currentPosition = Position(longitude: 0, latitude: 0, timestamp:null, accuracy:2, altitude:2, heading: 2, speed: 2, speedAccuracy: 3);
  String _currentAddress = '';


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        
        title: Text('Geolocatizador'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
 
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            if(_currentPosition != null)Text(
              //"LAT: ${_currentPosition?.latitude}, LNG: ${_currentPosition?.longitude}"
              _currentAddress
            ),
            MaterialButton(
              child: const Text('Geolocalizador', style: TextStyle(color: Colors.white),),
              color: Colors.blueAccent,
              shape: const StadiumBorder(),
              elevation: 0,
              splashColor: Colors.transparent,
              onPressed: () {
                _getCurrentLocation();
              },
            )
           
          ],
        ),
      ),
     
    );
  }

  _getCurrentLocation()async{
    LocationPermission permission;
   permission = await Geolocator.requestPermission();
    Geolocator
    .getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
    .then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLng();
      });
    }).catchError((e){
      print(e);
    });
  }

  _getAddressFromLatLng() async{
    try{
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition.latitude,
        _currentPosition.longitude
      );
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    }catch(e){
      // ignore: avoid_print
      print(e);
    }
  }
}
