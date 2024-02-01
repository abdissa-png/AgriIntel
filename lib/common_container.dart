import 'package:flutter/material.dart';

class CommonContainer extends StatelessWidget {
  final String textContent;

  CommonContainer({required this.textContent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.black87,
      
        child: Text(
        textContent,
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.white, // Customize text color as needed
        ),
      ),
    );
  }
}
