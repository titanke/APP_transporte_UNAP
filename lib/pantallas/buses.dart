import 'package:flutter/material.dart';
import "package:app_transporte_prototipo/main.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class Buses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todosLosDatos.length,
      itemBuilder: (context, index) {
        return Card(
          child: Container(
          height: 80.0,
          child: ListTile(
              onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Menu()),

            );            },
        leading: Padding(
              padding: EdgeInsets.only(top:16.0), 
              child: Column(
                children: <Widget>[
                  Icon(FontAwesomeIcons.bus, color: Colors.blue),
                  Text('A 100m'),
                ],
              ),
            ),
            title: Text('Bus ${index + 1}'),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(              
                  padding: EdgeInsets.only(top:6.0), 
                  child:  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.0), // Ajusta el valor del radio como necesites
                    ),
                    padding: EdgeInsets.all(2.0), // Añade padding si es necesario
                    child: Text('En camino',style: TextStyle(color: Colors.white),),
                  ),
                ),
                SizedBox(height: 12.0),
                Text('Capacidad: 10/38', style: TextStyle(backgroundColor: const Color.fromARGB(0, 200, 230, 201))),
              ],
            ),
          ),
          ),
        );
      },
    );
  }
}
