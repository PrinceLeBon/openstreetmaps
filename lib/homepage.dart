import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:openstreetmap/maps.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final formKey = GlobalKey<FormState>();
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Openstreetmap Flutter"),
        ),
        body: Center(
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    style: const TextStyle(fontSize: 13, color: Colors.black),
                    controller: myController1,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter city's name";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.location_city),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        hintText: "Enter start's location"),
                  ),
                  TextFormField(
                    style: const TextStyle(fontSize: 13, color: Colors.black),
                    controller: myController2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter city's name";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.location_city),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        hintText: "Enter destination's location"),
                  ),
                  TextButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          List<Location> locations1 = await locationFromAddress(
                              myController1.text.trim());
                          List<Location> locations2 = await locationFromAddress(
                              myController2.text.trim());
                          if (kDebugMode) {
                            print(locations1);
                            print(locations1.length.toString());
                            print(locations2);
                            print(locations2.length.toString());
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => Maps(
                                      long1: locations1.first.longitude,
                                      long2: locations2.first.longitude,
                                      lat1: locations1.first.latitude,
                                      lat2: locations2.first.latitude)));
                        }
                      },
                      child: const Text("Go to the map"))
                ],
              )),
        ));
  }
}
