import 'package:flutter/material.dart';
import "package:app_transporte_prototipo/pantallas/ruta.dart";
import "package:app_transporte_prototipo/main.dart";

class Horario extends StatelessWidget {
  final colorper = Color.fromRGBO(7, 3, 49, 1); // Rojo sólido (RGB: 255, 0, 0)
final List<Map<String, String>> datos = [
  {
    'hora': '6:30 AM ',
    'lugar': 'Parque Salcedo',
    'mensaje': 'Salida mañana',
  },
  {
    'hora': '6:30 AM - 8:00 AM',
    'lugar': 'Torres San Carlos',
    'mensaje': 'Salida mañana',
  },
  {
    'hora': '6:30 AM - 8:00 AM',
    'lugar': 'Parque Dante Nava',
    'mensaje': 'Salida mañana',
  },
  {
    'hora': '11:45 AM - 2:00 PM',
    'lugar': 'Ciudad Universitaria',
    'mensaje': 'Salida medio dia',
  },
    {
    'hora': '6:00 PM - 8:00 PM',
    'lugar': 'Ciudad Universitaria',
    'mensaje': 'Salida noche',
  },
  ];
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(99, 139, 211, 1),
      body: Column(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapaRuta()),
              );
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: datos.length,
              itemBuilder: (context, index) {
                final isEven = index % 2 == 0; // Check if index is even
                final hora = datos[index]['hora'];
                final lugar = datos[index]['lugar'];
                final mensaje = datos[index]['mensaje'];
                final cardColor = isEven
                    ? colorper // Set white for even indices
                    : Colors.blueAccent; // Set gray for odd indices

                return Card(
                  color: cardColor, // Apply the calculated color
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 40.0,
                          child: Icon(
                            Icons.pin_drop,
                            size: 30.0,
                            color: Colors.white,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                hora!,
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                lugar!,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(mensaje!),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

