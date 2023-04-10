import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart' as _location;
import 'homepage.dart';
import 'maps.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  _location.Location location = _location.Location();

  bool serviceEnabled;
  _location.PermissionStatus permissionGranted;
  _location.LocationData locationData;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == _location.PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != _location.PermissionStatus.granted) {
      return;
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Maps(),
    );
  }
}