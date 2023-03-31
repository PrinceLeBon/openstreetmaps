import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:location/location.dart' as _location;

class Maps extends StatefulWidget {
  final double long1;
  final double long2;
  final double lat1;
  final double lat2;

  const Maps(
      {Key? key,
      required this.long1,
      required this.long2,
      required this.lat1,
      required this.lat2})
      : super(key: key);

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  late MapController mapController = MapController.withPosition(
    initPosition: GeoPoint(latitude: widget.lat1, longitude: widget.long1),
    areaLimit: const BoundingBox.world(),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //route();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tap on icon to draw road"),
        actions: [
          IconButton(
              onPressed: () async {
                route();
              },
              icon: const Icon(Icons.download))
        ],
      ),
      body: OSMFlutter(
        controller: mapController,
        trackMyPosition: true,
        initZoom: 12,
        stepZoom: 1.0,
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
    );
  }

  Future<void> route() async {
    RoadInfo roadInfo = await mapController.drawRoad(
      GeoPoint(latitude: widget.lat1, longitude: widget.long1),
      GeoPoint(latitude: widget.lat2, longitude: widget.long2),
      roadType: RoadType.car,
      roadOption: const RoadOption(
        roadWidth: 10,
        roadColor: Colors.blue,
        zoomInto: true,
      ),
    );
    print("${roadInfo.distance}km");
    print("${roadInfo.duration}sec");
    print("${roadInfo.instructions}");
  }
}
