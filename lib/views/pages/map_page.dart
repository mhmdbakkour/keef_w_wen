import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../classes/data/event.dart';
import '../../classes/data/user.dart';
import '../../classes/providers.dart';
import '../widgets/event_marker_widget.dart';
import 'event_details_page.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  final MapController mapController = MapController();
  double currentZoom = 13.0;
  double currentRotation = 0.0;
  final double minZoom = 10.0;
  final double maxZoom = 18.0;
  List<LatLng> polylinePoints = [];
  LatLng? userLocation;
  bool routing = false;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      final status = await Permission.location.request();
      if (status.isGranted) {
        Position position = await Geolocator.getCurrentPosition();
        if (!mounted) return;
        setState(() {
          userLocation = LatLng(position.latitude, position.longitude);
        });
      } else {
        debugPrint("Location permission denied");
      }
    } catch (e) {
      debugPrint("Error getting location: $e");
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

  void zoomIn() async {
    setState(() {
      if (currentZoom < maxZoom) {
        currentZoom += 1;
        mapController.move(mapController.camera.center, currentZoom);
      }
    });
  }

  void zoomOut() {
    setState(() {
      if (currentZoom > minZoom) {
        currentZoom -= 1;
        mapController.move(mapController.camera.center, currentZoom);
      }
    });
  }

  void locateUser() {
    if (userLocation != null) {
      mapController.move(userLocation!, 16.0);
      mapController.rotate(0.0);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User loggedUser = ref.watch(loggedUserProvider).user;
    final List<Event> events = ref.watch(eventProvider).events;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        margin: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              if (userLocation != null)
                FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter:
                        events[0].coordinates, //reset to userLocation!
                    initialZoom: 13.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      userAgentPackageName: 'com.example.keef_w_wen',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          alignment: Alignment.center,
                          point: userLocation!,
                          width: 40.0,
                          height: 40.0,
                          child: Icon(
                            Icons.my_location,
                            color: Colors.red,
                            size: 40.0,
                          ),
                        ),
                        ...events.map((e) {
                          return EventMarker(
                            coordinates: e.coordinates,
                            title: e.title,
                            thumbnailUrl: e.thumbnailSrc,
                            color:
                                e.participants.any(
                                      (p) => p.username == loggedUser.username,
                                    )
                                    ? Theme.of(
                                      context,
                                    ).colorScheme.tertiaryContainer
                                    : Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          EventDetailsPage(eventId: e.id),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ],
                    ),
                    if (polylinePoints.isNotEmpty)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: polylinePoints,
                            strokeWidth: 5.0,
                            color:
                                Theme.of(context).colorScheme.tertiaryContainer,
                          ),
                        ],
                      ),
                  ],
                )
              else
                Center(child: CircularProgressIndicator()),

              if (userLocation != null)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        mini: true,
                        heroTag: 'center',
                        onPressed: locateUser,
                        child: Icon(Icons.my_location),
                      ),
                    ],
                  ),
                ),
              if (userLocation != null)
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).colorScheme.surfaceContainer,
                    ),
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: zoomIn,
                          icon: const Icon(Icons.add),
                        ),
                        IconButton(
                          onPressed: zoomOut,
                          icon: const Icon(Icons.remove),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
