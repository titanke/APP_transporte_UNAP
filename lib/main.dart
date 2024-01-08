import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Mapa(),
    );
  }
}
class Mapa extends StatefulWidget {
  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
    LatLng busLocation = LatLng(-15.824700537763, -70.01609754700355); // Ubicación inicial
    @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('locations').doc('bus_p').snapshots().listen((doc) {
      GeoPoint point = doc.data()?['location'];
      setState(() {
        busLocation = LatLng(point.latitude, point.longitude);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      
          title: Text("App Transporte"),
        ),
         drawer: Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text('Usuario'),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
          title: Text('Mostrar todos los buses'),
          onTap: () {
            // Update the state of the app.
            // Then close the drawer.
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Horario'),
          onTap: () {
            // Update the state of the app.
            // Then close the drawer.
            Navigator.pop(context);
          },
        ),
            ListTile(
          title: Text('Reportar problemas'),
          onTap: () {
            // Update the state of the app.
            // Then close the drawer.
            Navigator.pop(context);
          },
        ),
      ],
    ),
  ),
      body: FlutterMap(
            options: MapOptions(
              center: LatLng(-15.843315072805986, -70.02529877933655),
              zoom: 15,
              maxZoom: 19,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                maxZoom: 19,
              ),
              CurrentLocationLayer(
                followOnLocationUpdate: FollowOnLocationUpdate.always,
                turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
                style: LocationMarkerStyle(
                  marker: const DefaultLocationMarker(
                    child: Icon(
                      Icons.navigation,
                      color: Colors.white,
                    ),
                  ),
                  markerSize: const Size(40, 40),
                  markerDirection: MarkerDirection.heading,
                ),
              ),
                  MarkerLayer(
                markers: [
               Marker(
                point: busLocation,
                  child: Icon(Icons.bus_alert,color: Colors.green),
                ),

            
                ],
    ),
            ],
          )
    );
    
  }
}
