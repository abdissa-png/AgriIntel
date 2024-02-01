import 'package:crop_recommendation/DamageDetection.dart';
import 'package:crop_recommendation/Recommended.dart';
import 'package:crop_recommendation/WeedDetection.dart';
import 'package:crop_recommendation/dataprovider/provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'DiseaseDetection.dart';
import './Landing.dart';
import 'recommendation.dart';
import './login.dart';
import './registration.dart';

void main() async {
  Provider.addInterceptor();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _router = GoRouter(routes: [
    GoRoute(
        path: '/DiseaseDetection',
        builder: ((context, state) => DiseaseDetection())),
    GoRoute(
        path: '/WeedDetection', builder: ((context, state) => WeedDetection())),
    GoRoute(
        path: '/DamageDetection',
        builder: ((context, state) => DamageDetection())),
    GoRoute(
        path: '/recommendation',
        builder: ((context, state) => Recommendation())),
    GoRoute(path: '/recommended', builder: ((context, state) => Recommended())),
    GoRoute(path: '/', builder: ((context, state) => LoginPage())),
    GoRoute(
        path: '/registration',
        builder: ((context, state) => RegistrationPage())),
    GoRoute(path: '/login', builder: ((context, state) => LoginPage())),
    GoRoute(path: '/home', builder: ((context, state) => LandingPage())),
  ]);
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Automated Crop Guidance',
        routerConfig: _router,
        theme: ThemeData(
          colorScheme: ColorScheme.light().copyWith(primary: Colors.black12),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: Colors.black87,
              onPrimary: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9.0),
              ),
              textStyle: TextStyle(
                fontSize: 16,
              ),
              elevation: 10,
            ),
          ),
        ));
  }
}
