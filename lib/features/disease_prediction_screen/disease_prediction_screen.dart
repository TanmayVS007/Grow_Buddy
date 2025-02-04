import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:http_parser/http_parser.dart';

class DiseasePredictionScreen extends StatefulWidget {
  static const String routeName = "/disease-prediction-screen";
  const DiseasePredictionScreen({super.key});

  @override
  State<DiseasePredictionScreen> createState() =>
      _DiseasePredictionScreenState();
}

class _DiseasePredictionScreenState extends State<DiseasePredictionScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String? disease = "";
  Future<void> _selectFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _predictDisease() async {
    if (_image == null) {
      Fluttertoast.showToast(
        msg: "Please select an image first",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    try {
      if (kDebugMode) {
        print("Predict Disease function called");
      }
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.94.31:5000/predict'),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          _image!.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
      var response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final Map<String, dynamic> predictionData = json.decode(responseData);
        String predictedDisease = predictionData['prediction'];
        setState(() {
          disease = predictedDisease;
        });

        Fluttertoast.showToast(
          msg: "Prediction: $predictedDisease",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to get prediction. Try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error occurred1: $e");
      }
      Fluttertoast.showToast(
        msg: "Error occurred2: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<void> _searchDiseaseOnGoogle(String diseaseName) async {
    final query = Uri.encodeComponent(diseaseName);
    final url = 'https://www.google.com/search?q=$query';
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Fluttertoast.showToast(
        msg: "Could not open browser",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disease Prediction'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 20.0,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _selectFromGallery,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Select from Gallery'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _takePhoto,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Take Photo'),
                ),
              ],
            ),
            SizedBox(height: height * .05),
            _image != null
                ? Container(
                    width: width * .8,
                    height: height * .4,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    width: width * .8,
                    height: height * .4,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'No image selected.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
            SizedBox(height: height * .04),
            ElevatedButton(
              onPressed: _predictDisease,
              child: const Text(
                "Detect Disease",
              ),
            ),
            SizedBox(height: height * .03),
            disease != "" || disease != null
                ? InkWell(
                    onTap: () {
                      _searchDiseaseOnGoogle(disease!);
                    },
                    child: Container(
                      height: height * .05,
                      width: width * .8,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Predicted Disease: $disease",
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
