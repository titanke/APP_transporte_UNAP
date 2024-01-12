import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:app_transporte_prototipo/widgets/customtile.dart";
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import "package:app_transporte_prototipo/pantallas/buses.dart";
import "package:app_transporte_prototipo/pantallas/horarios.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

Future<String> calcularDistancia(LatLng busLocation) async {
  Position miPosicion = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  double distanciaEnMetros = Geolocator.distanceBetween(
    miPosicion.latitude,
    miPosicion.longitude,
    busLocation.latitude,
    busLocation.longitude,
  );
  return '${distanciaEnMetros.toStringAsFixed(2)} metros';
}

Future<String> obtenerDireccion(LatLng busLocation) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(
      busLocation.latitude, busLocation.longitude);
  Placemark lugar = placemarks[0];
  return lugar.street ?? 'Dirección no disponible';
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Trasnporte',
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
  LatLng busLocation =
      LatLng(-15.824700537763, -70.01609754700355); 
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
      appBar: AppBar(
        title: Text("App Transporte",
            style: TextStyle(
              color: Colors.white,
            )),
        backgroundColor: Color.fromARGB(255, 59, 82, 126),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Usuario',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 59, 82, 126),
              ),
            ),
            ListTile(
              title: Text('Mostrar todos los buses'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MiPantalla()),
                );
              },
            ),
            ListTile(
                title: Text('Horario'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MiHorario()),
                  );
                }),
            ListTile(
              title: Text('Reportar problemas'),
              onTap: () {
        
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
                                  rightText: '20/38'),
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
      floatingActionButton: Container(
        padding: EdgeInsets.all(8),
        width: 350,
        height: 50,
        child: TextButton.icon(
          onPressed: () {
            print('Botón de bus presionado');
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
                          leftText: 'Hora de Partida', rightText: '10:00am'),
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
                          rightText: '20/38'),
                    ],
                  ),
                );
              },
            );
          },
          icon: Icon(Icons.directions_bus, color: Colors.white),
          label: Text('Informacion del bus',
              style: TextStyle(color: Colors.white)),
          style: TextButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 59, 82, 126),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.0),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
