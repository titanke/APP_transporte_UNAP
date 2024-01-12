import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String leftText;
  final String rightText;

  CustomListTile({required this.leftText, required this.rightText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 15, 50, 114),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              leftText,
              style: TextStyle(color: Colors.white),
            ),
            Text(
              rightText,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        onTap: () => {},
      ),
    );
  }
}
