import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:app_transporte_prototipo/widgets/customtile.dart";

import "package:app_transporte_prototipo/main.dart";


class Mapa extends StatefulWidget {
  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  LatLng busLocation = LatLng(-15.824700537763, -70.01609754700355);
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('locations')
        .doc('bus_p')
        .snapshots()
        .listen((doc) {
      GeoPoint point = doc.data()?['location'];
      setState(() {
        busLocation = LatLng(point.latitude, point.longitude);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                width: 80.0,
                height: 80.0,
                point: busLocation,
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          color: Color.fromARGB(255, 59, 82, 126),
                          child: Wrap(
                            children: <Widget>[
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Text(
                                    "Bus 1",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              CustomListTile(
                                  leftText: 'Hora de Partida',
                                  rightText: '10:00am'),
                              FutureBuilder<String>(
                                future: calcularDistancia(busLocation),
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else {
                                    if (snapshot.hasError)
                                      return Text('Error: ${snapshot.error}');
                                    else
                                      return CustomListTile(
                                          leftText: 'Distancia',
                                          rightText: snapshot
                                              .data!); // snapshot.data contiene tu String
                                  }
                                },
                              ),
                              FutureBuilder<String>(
                                future: obtenerDireccion(busLocation),
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else {
                                    if (snapshot.hasError)
                                      return Text('Error: ${snapshot.error}');
                                    else
                                      return CustomListTile(
                                          leftText: 'Ubicación',
                                          rightText: snapshot
                                              .data!); // snapshot.data contiene tu String
                                  }
                                },
                              ),
                              CustomListTile(
                                  leftText: 'Capacidad del Vehiculo',
                                  rightText: '20/38'
                                  ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.bus_alert_outlined), // Este es tu ícono
                        Text('Bus 1'), // Este es tu texto
                      ],
                    ),
                  ),
                ),
              ),
              Marker(
                point: LatLng(-15.846069499999999, -70.02184668466012),
                child: Icon(
                  Icons.store_sharp,
                  color: Colors.blueAccent,
                  size: 50,
                ),
              )
            ],
          ),
        ],
      ),

  
    );
  }
}
