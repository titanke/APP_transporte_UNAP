
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String leftText;
  final String rightText;

  CustomListTile({required this.leftText, required this.rightText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(15),
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
