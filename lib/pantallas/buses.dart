import 'package:flutter/material.dart';
import "package:app_transporte_prototipo/main.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Buses extends StatelessWidget {
  Future<List> fetchBuses() async {
    await obtenerDocumentos();
    return todosLosDatos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(99, 139, 211, 1),
      body: FutureBuilder<List>(
        future: fetchBuses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data!.isEmpty) {
            return Center(child: Text('No hay buses disponibles'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Container(
                    height: 80.0,
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Menu()),
                        );
                      },
                      leading: Padding(
                        padding: EdgeInsets.only(top: 16.0, left: 5, right: 5),
                        child: Column(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.bus,
                              color: Colors.black,
                              size: 40,
                            ),
                          ],
                        ),
                      ),
                      title: Text('BUS ${index + 1}\na 100m',style: TextStyle(color: Colors.black),),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 8.0, right: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: EdgeInsets.all(2.0),
                              child: Text(
                                'En camino',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(height: 6.0),
                          Text(
                            'Capacidad: 10/38',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
