import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<LatLng> polylinePoints = [];
  LatLng? userLocation;
  final LatLng endPoint = LatLng(33.8846, 35.5034);
  bool routing = false;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> _getRoute() async {
    if (userLocation == null) return;

    try {
      List<LatLng> points = await getRouteGraphHopper(
        userLocation!.latitude,
        userLocation!.longitude,
        endPoint.latitude,
        endPoint.longitude,
      );

      setState(() {
        polylinePoints = points;
      });
    } catch (e) {
      print("Error fetching route: $e");
    }
  }

  Future<List<LatLng>> getRouteGraphHopper(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) async {
    final String apiKey = "496924f3-616e-4786-864b-ce4c5e1e440e";
    final String url = "https://graphhopper.com/api/1/route";

    final response = await http.get(
      Uri.parse(
        "$url?point=$startLat,$startLng&point=$endLat,$endLng&profile=car&locale=en&calc_points=true&key=$apiKey",
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<LatLng> routePoints = [];

      if (data["paths"] != null && data["paths"].isNotEmpty) {
        final String encodedPolyline = data["paths"][0]["points"];
        routePoints = decodePolyline(encodedPolyline);
      }

      return routePoints;
    } else {
      throw Exception("Failed to fetch route: ${response.body}");
    }
  }

  /// Decode polyline into a list of LatLng points
  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int shift = 0, result = 0;
      int byte;

      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      int deltaLat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += deltaLat;

      shift = 0;
      result = 0;

      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      int deltaLng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += deltaLng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return polyline;
  }

  @override
  Widget build(BuildContext context) {
    return userLocation == null
        ? Center(child: CircularProgressIndicator())
        : Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: userLocation!,
                initialZoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://tile.openstreetmap.org/{z}/{x}/{y}.png?lang=en",
                  userAgentPackageName: 'com.example.keef_w_wen',
                ),
                MarkerLayer(
                  markers: [
                    if (!routing)
                      Marker(
                        point: userLocation!,
                        width: 40.0,
                        height: 40.0,
                        child: Icon(
                          Icons.location_history,
                          color: Colors.red,
                          size: 40.0,
                        ),
                      ),
                    if (routing)
                      Marker(
                        point: endPoint,
                        width: 40.0,
                        height: 40.0,
                        child: Icon(
                          Icons.location_pin,
                          color: Colors.blue,
                          size: 40.0,
                        ),
                      ),
                  ],
                ),
                if (polylinePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: polylinePoints,
                        strokeWidth: 5.0,
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                      ),
                    ],
                  ),
              ],
            ),
            TextButton(
              onPressed: () {
                routing = !routing;
                if (routing) _getRoute();
              },
              child: Text("Route map"),
            ),
          ],
        );
  }
}
