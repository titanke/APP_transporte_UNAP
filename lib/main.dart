import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import "package:app_transporte_prototipo/pantallas/buses.dart";
import "package:app_transporte_prototipo/pantallas/horarios.dart";
import "package:app_transporte_prototipo/pantallas/mapa.dart";
import "package:app_transporte_prototipo/widgets/p_gracias.dart";
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:device_info_plus/device_info_plus.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

final todosLosDatos = [];
Future<void> obtenerDocumentos() async {
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('locations');
  QuerySnapshot querySnapshot = await _collectionRef.get();
  todosLosDatos.clear();

  todosLosDatos.addAll(querySnapshot.docs.map((doc) => doc.data()).toList());
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
        appBarTheme: AppBarTheme(
            backgroundColor: Color.fromARGB(255, 58, 89, 127),
        ),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 95, 142, 207),
          brightness: Brightness.dark,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 95, 142, 207)
        ),
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.white
        )
      ),
      initialRoute: '/',
      routes: {
        '/Horario': (context) => Horario(),
        '/Mapa': (context) => Mapa(),
        '/Buses': (context) => Buses(),
      },
      home: AnimatedSplashScreen(
        splash: Scaffold(
          backgroundColor: Color.fromRGBO(3, 29, 51, 1),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/unap.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    "UNAPGO",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  child: Text(
                    "Buscando el bus mas cercano....",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
        duration: 1000,
        splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Color.fromRGBO(3, 29, 51, 1),
        nextScreen: Menu(),
        splashIconSize: MediaQuery.of(context).size.height,
      ),
    );
  }
}

class Menu extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
  
}

class _MyHomePageState extends State<Menu> {

  void initState() {
    super.initState();
     obtenerDocumentos();

  }

  int _currentIndex = 1;
  final List<Widget> _children = [Horario(), Mapa(), Buses()];
  final _titles = ['Ruta', 'UNAP GO', 'Buses'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(_titles[_currentIndex]),
            actions: _currentIndex == 1 ? <Widget>[
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
            ] : null,
          ),
      body: IndexedStack(
        index: _currentIndex,
        children: _children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem> [
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Ruta',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.gps_fixed),
              label: 'Localizar',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.bus),
              label: 'Buses',
            ),
          ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
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
          Padding(
            padding: EdgeInsets.all(
                8.0), // Ajusta el valor del padding según tus necesidades
            child: SizedBox(
              width: double
                  .infinity, // Esto hace que el botón se extienda horizontalmente
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Cambia esto al color que prefieras
                ),
                onPressed: () async {
                  try {
                    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                    AndroidDeviceInfo androidInfo =
                        await deviceInfo.androidInfo;
                    String? deviceName =
                        androidInfo.model; // Obtiene el nombre del dispositivo

                    // Enviar comentario a Firestore
                    await FirebaseFirestore.instance
                        //                        .doc(deviceName) // Usa el nombre del dispositivo como el nombre del document
                        .collection('comentarios')
                        .add({
                      'comentario': _commentController.text,
                    });
                    print(_commentController.text);
                    Navigator.of(context).pop();
                  } catch (e) {
                    // Manejar el error
                    print("Ocurrió un error al enviar los datos: $e");
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Pgracias()),
                  );
                },
                child: Text('Enviar', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
