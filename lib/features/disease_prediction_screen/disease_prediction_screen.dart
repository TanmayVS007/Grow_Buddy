import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DiseasePredictionScreen extends StatefulWidget {
  static const String routeName = "/disease-prediction-screen";
  const DiseasePredictionScreen({super.key});

  @override
  State<DiseasePredictionScreen> createState() =>
      _DiseasePredictionScreenState();
}

class _DiseasePredictionScreenState extends State<DiseasePredictionScreen> {
  File? _image; // To store the selected/taken image
  final ImagePicker _picker = ImagePicker(); // Image picker instance
  String? disease = "Apple_rot";

  // Method to select image from gallery
  Future<void> _selectFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Store the selected image
      });
    }
  }

  // Method to take a picture using camera
  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Store the taken picture
      });
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
            // Display the preview of the selected/taken image
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
            // Integrate the api of disease detection
            ElevatedButton(
              onPressed: () {
                _image == null
                    ? Fluttertoast.showToast(
                        msg: "Please select an Image",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      )
                    : Fluttertoast.showToast(
                        msg: "Got the image",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
              },
              child: const Text(
                "Detect Disease",
              ),
            ),
            SizedBox(height: height * .03),
            disease != "" || disease != null
                ? InkWell(
                    onTap: () {},
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
