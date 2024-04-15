import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapaRuta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text('Ruta')),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(-15.843315072805986, -70.02529877933655),
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
          PolylineLayer(
            polylines: [
              Polyline(
                points:
                    ruta(), // Función que devuelve la lista de puntos de la ruta
                strokeWidth: 4.0,
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<LatLng> ruta() {
    return [
      LatLng(-15.824637149408208, -70.01620027483662), // Punto de inicio
      LatLng(-15.828181025921499, -70.01695529604565),
      LatLng(-15.832047099034405, -70.02251856255272),

      LatLng(-15.832555800665212, -70.02418953391916),

      LatLng(-15.840328259789558, -70.0219134440779),
      LatLng(-15.84171009367446, -70.02557981000632),
      LatLng(-15.84335740345098, -70.02475990737705),

      LatLng(-15.846048622381234, -70.02218048443694), // Punto de fin
    ];
  }
}
