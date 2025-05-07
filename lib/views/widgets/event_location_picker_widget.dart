import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

class EventLocationPicker extends StatefulWidget {
  final void Function(LatLng, String) onLocationSelected;
  final LatLng? savedCoordinates;

  const EventLocationPicker({
    super.key,
    required this.onLocationSelected,
    this.savedCoordinates,
  });

  @override
  State<EventLocationPicker> createState() => _EventLocationPickerState();
}

class _EventLocationPickerState extends State<EventLocationPicker> {
  static const lebCoords = LatLng(33.8547, 35.8623);
  final MapController mapController = MapController();
  LatLng? selectedPosition;
  String? locationName;

  Future<void> _updateLocation(LatLng pos) async {
    setState(() {
      selectedPosition = pos;
      locationName = null;
    });
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark? bestMatch;
        for (var placemark in placemarks) {
          bool hasValidLocality =
              placemark.locality != null && placemark.locality!.isNotEmpty;
          bool hasReadableName =
              placemark.name != null &&
              placemark.name!.isNotEmpty &&
              !RegExp(r'^[A-Z0-9\+\-]+$').hasMatch(placemark.name!);

          if (hasValidLocality && hasReadableName) {
            bestMatch = placemark;
            break;
          }
        }

        final place = bestMatch ?? placemarks.first;

        setState(() {
          locationName = "${place.name}, ${place.subAdministrativeArea}";
        });
      }
    } catch (e) {
      setState(() {
        locationName = "Unknown location";
      });
    }
  }

  void resetMap() {
    setState(() {
      mapController.move(lebCoords, 8);
      mapController.rotate(0.0);
    });
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool coordinatesSaved =
        widget.savedCoordinates != null &&
        widget.savedCoordinates!.longitude != 0 &&
        widget.savedCoordinates!.latitude != 0;
    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter:
                coordinatesSaved ? widget.savedCoordinates! : lebCoords,
            initialZoom: coordinatesSaved ? 16 : 8,
            onTap: (tapPos, point) => _updateLocation(point),
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: 'com.example.keef_w_wen',
            ),
            if (selectedPosition != null)
              MarkerLayer(
                markers: [
                  Marker(
                    alignment: Alignment.topCenter,
                    width: 40,
                    height: 40,
                    point: selectedPosition!,
                    child: Icon(
                      Icons.location_pin,
                      size: 40,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            if (selectedPosition == null && coordinatesSaved)
              MarkerLayer(
                markers: [
                  Marker(
                    alignment: Alignment.topCenter,
                    width: 40,
                    height: 40,
                    point: widget.savedCoordinates!,
                    child: Icon(
                      Icons.location_pin,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Align(
            alignment: Alignment.topLeft,
            child: Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  "Event Location",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: GestureDetector(
            onTap: resetMap,
            child: Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Container(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.center_focus_strong,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
        ),
        if (locationName != null)
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Card(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                padding: EdgeInsets.all(8),
                child: Text(
                  "${selectedPosition!.latitude.toStringAsFixed(5)}, ${selectedPosition!.longitude.toStringAsFixed(5)}\n$locationName",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ),
        if (locationName != null)
          Positioned(
            bottom: 10,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed:
                  selectedPosition != null && locationName != null
                      ? () {
                        widget.onLocationSelected(
                          selectedPosition!,
                          locationName!,
                        );
                        Navigator.of(context).pop();
                      }
                      : null,
              child: Text('Confirm Location'),
            ),
          ),
      ],
    );
  }
}
