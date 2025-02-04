import 'package:flutter/material.dart';
import 'package:grow_buddy/common/bottom_bar.dart';
import 'package:grow_buddy/features/crop_screen/crops_screen.dart';
import 'package:grow_buddy/features/disease_prediction_screen/disease_prediction_screen.dart';
import 'package:grow_buddy/features/login_screen/login_screen.dart';
import 'package:grow_buddy/features/price_prediction_screen/price_prediction_screen.dart';
import 'package:grow_buddy/features/profile_screen/profile_screen.dart';
import 'package:grow_buddy/features/register_screen/register_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBar(),
      );
    case ProfileScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ProfileScreen(),
      );
    case CropsScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const CropsScreen(),
      );
    case DiseasePredictionScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const DiseasePredictionScreen(),
      );
    case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const LoginScreen(),
      );
    case RegisterScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const RegisterScreen(),
      );
    case PricePredictionScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const PricePredictionScreen(),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text("Screen do not exist"),
          ),
        ),
      );
  }
}
