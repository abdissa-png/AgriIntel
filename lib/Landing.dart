import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crop Disease App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Agrintel",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                context.go('/DiseaseDetection');
              },
              child: Text("Detect Crop Disease"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.go('/recommendation');
              },
              child: Text("Get Crop Recommendations"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.go('/DamageDetection');
              },
              child: Text("Assess Crop Damage"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.go('/WeedDetection');
              },
              child: Text("Identify Weeds in Your Field"),
            ),
          ],
        ),
      ),
    );
  }
}
