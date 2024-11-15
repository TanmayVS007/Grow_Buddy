// ignore_for_file: sized_box_for_whitespace

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PricePredictionScreen extends StatefulWidget {
  static const String routeName = '/price-prediction-screen';
  const PricePredictionScreen({super.key});

  @override
  State<PricePredictionScreen> createState() => _PricePredictionScreenState();
}

class _PricePredictionScreenState extends State<PricePredictionScreen> {
  String currentValue = "";
  String minValue = "";
  String maxValue = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final String cropName =
          ModalRoute.of(context)?.settings.arguments as String? ??
              "Unknown Crop";
      fetchPricePrediction(cropName);
    });
  }

  Future<void> fetchPricePrediction(String cropName) async {
    const String url = "http://192.168.0.16:5000/forecast";
    final Map<String, String> requestBody = {
      "croptype": cropName.toLowerCase()
    };

    try {
      print("Sending POST request to: $url");
      print("Request Body: $requestBody");

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          currentValue = data["average_price"].toString();
          minValue = data["min_price"].toString();
          maxValue = data["max_price"].toString();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        _showErrorDialog("Error fetching data. Please try again.");
      }
    } catch (e) {
      print("Error during API call: $e");
      setState(() {
        isLoading = false;
      });
      _showErrorDialog("Error: $e");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String cropName =
        ModalRoute.of(context)?.settings.arguments as String? ?? "Unknown Crop";
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(cropName),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10,
                    child: Container(
                      width: width * .9,
                      height: height * .2,
                      alignment: Alignment.center,
                      child: Text(
                        "Average Price: $currentValue",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10,
                    child: Container(
                      width: width * .9,
                      height: height * .2,
                      alignment: Alignment.center,
                      child: Text(
                        "Minimum Price: $minValue",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10,
                    child: Container(
                      width: width * .9,
                      height: height * .2,
                      alignment: Alignment.center,
                      child: Text(
                        "Maximum Price: $maxValue",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
