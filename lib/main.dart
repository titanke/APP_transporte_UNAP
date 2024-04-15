import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import "package:app_transporte_prototipo/pantallas/buses.dart";
import "package:app_transporte_prototipo/pantallas/horarios.dart";
import "package:app_transporte_prototipo/pantallas/mapa.dart";
import 'package:device_info_plus/device_info_plus.dart';

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
      home: Menu(),
    );
  }
}

//

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _selectedIndex = 1;

  List<Widget> _widgetOptions = <Widget>[
    Horario(),
    Mapa(),
    Buses(),
  ];

  @override
  Widget build(BuildContext context) {
    // Lista de títulos
    final _titles = ['Ruta', 'UNAP GO', 'Buses'];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          // Usar el índice seleccionado para obtener el título
          title: Text(_titles[_selectedIndex]),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.comment),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Enviar comentario'),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      content: CommentForm(),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Ruta',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Localizar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Buses',
            ),
          ],
        ),
      ),
    );
  }
}

//

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Mi AppBar'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.comment),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Enviar comentario'),
                  content: CommentForm(),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class CommentForm extends StatefulWidget {
  @override
  _CommentFormState createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
     TextFormField(
        controller: _commentController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Por favor ingresa un comentario';
          }
          return null;
        },
        style: TextStyle(
          // Estilo del texto
          fontSize: 18, // Tamaño del texto
        ),
        decoration: InputDecoration(
          fillColor: Colors.blue, // Color de fondo
          filled: true,
          contentPadding: EdgeInsets.symmetric(
            vertical: 25, // Espacio vertical
            horizontal: 10, // Espacio horizontal
          ),
          border: OutlineInputBorder(),
        ),
        maxLines: 5, // Número máximo de líneas
      ),

              ElevatedButton(
                onPressed: () async {
                  try {
                    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                    String? deviceName = androidInfo.model; // Obtiene el nombre del dispositivo

                    // Enviar comentario a Firestore
                    await FirebaseFirestore.instance
                        .collection('comentarios')
                        .doc(deviceName) // Usa el nombre del dispositivo como el nombre del documento
                        .set({
                      'comentario': _commentController.text,
                    });
                    print(_commentController.text);
                    Navigator.of(context).pop();
                  } catch (e) {
                    // Manejar el error
                    print("Ocurrió un error al enviar los datos: $e");
                  }
                },
                child: Text('Enviar'),
              ),
        ],
      ),
    );
  }
}
