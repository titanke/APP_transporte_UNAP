import 'package:flutter/material.dart';


class Buses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) {
        return Card(
          child: Container(
          height: 80.0,
          child: ListTile(
              onTap: () {
    // Vuelve a la pantalla principal cuando se toca el ListTile.
    Navigator.pop(context);
  },
        leading: Padding(
              padding: EdgeInsets.only(top:16.0), 
              child: Column(
                children: <Widget>[
                  Icon(Icons.bus_alert, color: Colors.blue),
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
