import 'package:flutter/material.dart';
class MiHorario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buses Disponobles'),
      ),
      body: Horario(),
    );
  }
}


class Horario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('6:30 am'),
                Text('Parque Salcedo', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Salida mañana'),
              ],
            ),
          ),
        );
      },
    );
  }
}
