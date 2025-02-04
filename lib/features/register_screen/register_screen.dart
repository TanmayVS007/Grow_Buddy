import "dart:io";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:grow_buddy/common/bottom_bar.dart";
import "package:grow_buddy/features/login_screen/login_screen.dart";
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = "/regtister-screen";
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _ageController = TextEditingController();
  final _mainCropsController = TextEditingController();
  final _landAreaController = TextEditingController();

  String? _profileImageUrl;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      await _uploadImage(imageFile);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      setState(() {
        _isLoading = true;
      });

      String fileName =
          'profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageRef.putFile(imageFile);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        if (kDebugMode) {
          print(
            'Upload progress: ${snapshot.bytesTransferred} / ${snapshot.totalBytes}',
          );
        }
      });
      TaskSnapshot snapshot = await uploadTask;
      if (snapshot.state == TaskState.success) {
        String imageUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          _profileImageUrl = imageUrl;
        });

        if (kDebugMode) {
          print("Image uploaded successfully. URL: $imageUrl");
        }
      } else {
        if (kDebugMode) {
          print("Image upload failed. Status: ${snapshot.state}");
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (kDebugMode) {
        print("Error uploading image: $e");
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _registerUser() async {
    // if (_formKey.currentState!.validate()) {
    try {
      setState(() {
        _isLoading = true;
      });
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'state': _stateController.text,
        'city': _cityController.text,
        'age': _ageController.text,
        'main_crops': _mainCropsController.text,
        'land_area': _landAreaController.text,
        'profile_image': _profileImageUrl ??
            '', // Allow null or empty string for profile image
      });
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacementNamed(
        context,
        BottomBar.routeName,
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (kDebugMode) {
        print("Error during registration: $e");
      }
    }
    // }
  }

  // Future<void> _saveUserDataToFirestore(String userId) async {
  //   await FirebaseFirestore.instance.collection('users').doc(userId).set({
  //     'name': _nameController.text,
  //     'email': _emailController.text,
  //     'phone': _phoneController.text,
  //     'state': _stateController.text,
  //     'city': _cityController.text,
  //     'age': _ageController.text,
  //     'main_crops': _mainCropsController.text,
  //     'land_area': _landAreaController.text,
  //   }).then((_) {
  //     if (kDebugMode) {
  //       print("User data saved to Firestore.");
  //     }
  //   }).catchError((error) {
  //     Fluttertoast.showToast(
  //       msg: "Error saving user data: $error",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .1,
                ),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _profileImageUrl == null
                        ? const AssetImage(
                            "assets/images/profile.png",
                          )
                        : NetworkImage(_profileImageUrl!) as ImageProvider,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your name" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your email" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your password" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your phone number" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _stateController,
                  decoration: const InputDecoration(
                    labelText: 'State',
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your state" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'City',
                    prefixIcon: Icon(Icons.location_city),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your city" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your age" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _mainCropsController,
                  decoration: const InputDecoration(
                    labelText: 'Main Crops',
                    prefixIcon: Icon(Icons.grain),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your main crops" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _landAreaController,
                  decoration: const InputDecoration(
                    labelText: 'Land Area (in acres)',
                    prefixIcon: Icon(Icons.landscape),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your land area" : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _registerUser,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Register"),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.routeName);
                  },
                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _ageController.dispose();
    _mainCropsController.dispose();
    _landAreaController.dispose();
    super.dispose();
  }
}
