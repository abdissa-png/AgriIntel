import 'dart:convert';
import 'package:crop_recommendation/Recommended.dart';
import 'package:crop_recommendation/dataprovider/mlprovider.dart';
import 'package:crop_recommendation/model/recommendation_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Recommendation extends StatefulWidget {
  @override
  _RecommendationState createState() => _RecommendationState();
}

class _RecommendationState extends State<Recommendation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recommendation"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Existing code...

            // Navigation to the new page
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DataEntryPage()),
                );
              },
              child: Text("Enter Data"),
            ),
          ],
        ),
      ),
    );
  }
}

String? val_range(String? value, num start, num end) {
  if (value == null || value.isEmpty) {
    return 'This field is required!';
  }
  num? parsedValue = num.tryParse(value);
  if (parsedValue == null) {
    return 'Please enter a valid number!';
  }
  bool within = (parsedValue >= start) && (parsedValue <= end);
  if (!within) {
    return 'Value must be within the range of [$start, $end]';
  } else {
    return null;
  }
}

class DataEntryPage extends StatefulWidget {
  @override
  _DataEntryPageState createState() => _DataEntryPageState();
}

class _DataEntryPageState extends State<DataEntryPage> {
  final TextEditingController pHController = TextEditingController();
  final TextEditingController temperatureController = TextEditingController();
  final TextEditingController nitrogenController = TextEditingController();
  final TextEditingController phosphorousController = TextEditingController();
  final TextEditingController potassiumController = TextEditingController();
  final TextEditingController humidityController = TextEditingController();
  final TextEditingController rainfallController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future<void> _sendData() async {
    try {
      dynamic response = await cropRecommendation(RecommendationData(
          ph: double.parse(pHController.text),
          temp: double.parse(temperatureController.text),
          N: double.parse(nitrogenController.text),
          P: double.parse(phosphorousController.text),
          K: double.parse(potassiumController.text),
          humidity: double.parse(humidityController.text),
          rainfall: double.parse(rainfallController.text)));
      var responseData = response['prediction'];

      // Display the server response in a dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Server Response"),
            content: Text(responseData),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (error) {
      print("Error sending data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Entry"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nitrogenController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Nitrogen'),
                  validator: (value) => val_range(value, 0, 100),
                ),
                TextFormField(
                  controller: phosphorousController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Phosphorous'),
                  validator: (value) => val_range(value, 0, 100),
                ),
                TextFormField(
                  controller: potassiumController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Potassium'),
                  validator: (value) => val_range(value, 0, 100),
                ),
                TextFormField(
                  controller: temperatureController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Temperature'),
                  validator: (value) =>
                      val_range(value, -double.infinity, double.infinity),
                ),
                TextFormField(
                  controller: humidityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'humidity'),
                  validator: (value) => val_range(value, 0, 100),
                ),
                TextFormField(
                  controller: pHController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'pH'),
                  validator: (value) => val_range(value, 0, 14),
                ),
                TextFormField(
                  controller: rainfallController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'rainfall'),
                  validator: (value) =>
                      val_range(value, -double.infinity, double.infinity),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  // onPressed: _sendData,

                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _sendData();
                      // context.go('/recommended');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Recommended()),
                      );
                    }
                  },
                  child: Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
