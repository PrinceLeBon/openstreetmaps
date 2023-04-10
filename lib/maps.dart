import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:location/location.dart' as _location;

class Maps extends StatefulWidget {
  /*final double long1;
  final double long2;
  final double lat1;
  final double lat2;*/

  const Maps({
    Key? key,
    /*required this.long1,
      required this.long2,
      required this.lat1,
      required this.lat2*/
  }) : super(key: key);

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  late MapController mapController = MapController.withPosition(
    initPosition: GeoPoint(latitude: 6.370293, longitude: 2.391236),
    areaLimit: const BoundingBox.world(),
  );

  late final PageController _pageController;
  int _currentIndex = 0;

  final List<Commande> commandes = [
    Commande('Commande 1', GeoPoint(latitude: 6.387370, longitude: 1.948700),
        Colors.red),
    Commande('Commande 2', GeoPoint(latitude: 6.448660, longitude: 2.357580),
        Colors.blue),
    Commande('Commande 3', GeoPoint(latitude: 6.663200, longitude: 2.150760),
        Colors.green),
    Commande('Commande 4', GeoPoint(latitude: 6.507188, longitude: 2.143707),
        Colors.yellow),
  ];

  List<StaticPositionGeoPoint> listeuh = [
    StaticPositionGeoPoint(
      "id1",
      const MarkerIcon(
          icon: Icon(
        Icons.location_history_outlined,
        size: 120,
        color: Colors.red,
      )),
      [GeoPoint(latitude: 6.370293, longitude: 2.391236)],
    )
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    for (var element in commandes) {
      listeuh.add(StaticPositionGeoPoint(
          element.name,
          MarkerIcon(
              icon: Icon(
            Icons.location_on_outlined,
            size: 120,
            color: element.couleur,
          )),
          [element.geopoint]));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Map"),
          actions: [
            IconButton(
                onPressed: () async {
                  //route();
                },
                icon: const Icon(Icons.download))
          ],
        ),
        body: Stack(
          children: [
            OSMFlutter(
              controller: mapController,
              trackMyPosition: false,
              initZoom: 19,
              stepZoom: 1,
              staticPoints: listeuh,
              /*userLocationMarker: UserLocationMaker(
          personMarker: const MarkerIcon(
            icon: Icon(
              Icons.location_history_rounded,
              color: Colors.red,
              size: 100,
            ),
          ),
          directionArrowMarker: const MarkerIcon(
            icon: Icon(
              Icons.double_arrow,
              size: 100,
            ),
          ),
        ),*/
              roadConfiguration: const RoadOption(
                roadColor: Colors.yellowAccent,
              ),
              markerOption: MarkerOption(
                  defaultMarker: const MarkerIcon(
                icon: Icon(
                  Icons.person_pin_circle,
                  color: Colors.blue,
                  size: 100,
                ),
              )),
            ),
            Positioned(
              bottom: 0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 150,
                child: PageView.builder(
                    controller: _pageController,
                    itemCount: 4,
                    onPageChanged: (index) {
                      setState(() async {
                        _currentIndex = index;
                        await mapController.clearAllRoads();
                      });
                    },
                    itemBuilder: (context, index) {
                      Commande commande = commandes[index];
                      route(commande.geopoint, commande.couleur);
                      return Container(
                        padding: const EdgeInsets.all(16),
                        color: Colors.white,
                        child: Column(
                          children: [
                            Text(commande.name),
                            Text(commande.geopoint.toString()),
                          ],
                        ),
                      );
                    }),
              ),
            )
          ],
        ));
  }

  Future<void> route(GeoPoint arrive, Color couleur) async {
    await mapController.drawRoad(
      GeoPoint(latitude: 6.370293, longitude: 2.391236),
      arrive,
      roadType: RoadType.bike,
      roadOption: RoadOption(
        roadWidth: 10,
        roadColor: couleur,
        zoomInto: true,
      ),
    );
  }

  String formatDuration(double seconds) {
    int hours = seconds ~/ 3600;
    seconds %= 3600;
    int minutes = seconds ~/ 60;
    seconds %= 60;
    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toStringAsFixed(0).padLeft(2, '0');
    return '$hoursStr:$minutesStr:$secondsStr';
  }
}

class Commande {
  final String name;
  final GeoPoint geopoint;
  final Color couleur;

  Commande(this.name, this.geopoint, this.couleur);
}
