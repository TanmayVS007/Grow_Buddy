import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grow_buddy/common/splash_screen.dart';
import 'package:grow_buddy/constants/global_variables.dart';
import 'package:grow_buddy/features/register_screen/register_screen.dart';
import 'package:grow_buddy/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Farmers Buddy",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        colorScheme: const ColorScheme.light(
          primary: GlobalVariables.secondaryColor,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: const SplashScreen(),
    );
  }
}
