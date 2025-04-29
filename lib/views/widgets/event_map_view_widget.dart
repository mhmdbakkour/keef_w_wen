import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'event_marker_widget.dart';

class EventMapView extends StatefulWidget {
  final LatLng coordinates;
  final String title;
  final String thumbnail;

  const EventMapView({
    super.key,
    required this.title,
    required this.coordinates,
    required this.thumbnail,
  });

  @override
  State<EventMapView> createState() => _EventMapViewState();
}

class _EventMapViewState extends State<EventMapView> {
  final MapController mapController = MapController();
  double currentZoom = 13.0;
  double currentRotation = 0.0;
  final double minZoom = 10.0;
  final double maxZoom = 18.0;

  @override
  void initState() {
    super.initState();
  }

  void zoomIn() {
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

  void rotateRight() {
    setState(() {
      currentRotation += 30.0;
      mapController.rotate(currentRotation);
    });
  }

  void rotateLeft() {
    setState(() {
      currentRotation -= 30.0;
      mapController.rotate(currentRotation);
    });
  }

  void centerOnEvent() {
    mapController.move(widget.coordinates, 16.0);
    mapController.rotate(0.0);
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: widget.coordinates,
            initialZoom: currentZoom,
            minZoom: minZoom,
            maxZoom: maxZoom,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.none,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: 'com.example.keef_w_wen',
            ),
            MarkerLayer(
              markers: [
                EventMarker(
                  title: widget.title,
                  coordinates: widget.coordinates,
                  thumbnail: widget.thumbnail,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Column(
            children: [
              FloatingActionButton(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                mini: true,
                heroTag: 'center',
                onPressed: centerOnEvent,
                child: Icon(Icons.location_pin),
              ),
            ],
          ),
        ),
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
                IconButton(onPressed: zoomIn, icon: const Icon(Icons.add)),
                IconButton(onPressed: zoomOut, icon: const Icon(Icons.remove)),
                IconButton(
                  onPressed: rotateRight,
                  icon: const Icon(Icons.rotate_right),
                ),
                IconButton(
                  onPressed: rotateLeft,
                  icon: const Icon(Icons.rotate_left),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
