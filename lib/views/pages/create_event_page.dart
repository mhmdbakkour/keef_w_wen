import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:keef_w_wen/classes/providers.dart';
import 'package:keef_w_wen/classes/repositories/event_repository.dart';
import 'package:keef_w_wen/data/constants.dart';
import 'package:keef_w_wen/views/widgets/form_text_widget.dart';
import 'package:keef_w_wen/views/widgets/tag_selector_widget.dart';
import 'package:latlong2/latlong.dart';

import '../../classes/data/location.dart';
import '../../classes/data/user.dart';
import '../widgets/event_location_picker_widget.dart';

class CreateEventPage extends ConsumerStatefulWidget {
  const CreateEventPage({super.key});

  @override
  ConsumerState<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends ConsumerState<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController eventTitleController = TextEditingController();
  final TextEditingController eventDescriptionController =
      TextEditingController();
  final TextEditingController eventPriceController = TextEditingController();
  final TextEditingController eventSeatsController = TextEditingController();

  DateTime? selectedDateStart;
  DateTime? selectedDateClosed;
  DateTime? selectedDateEnded;
  TimeOfDay? selectedTimeStart;
  TimeOfDay? selectedTimeClosed;
  TimeOfDay? selectedTimeEnded;
  File? selectedThumbnail;
  Location selectedLocation = Location.empty();
  List<File> selectedImages = [];
  List<String> selectedTags = [];
  bool isPrivateEvent = false;
  bool isPaidEvent = false;
  bool needsIdentification = false;
  String? dateValidator;
  String? locationValidator;
  final List<String> eventTags = AppConstants.eventTags;
  final GlobalKey _priceKey = GlobalKey();

  bool validateForm() {
    setState(() {
      dateValidator = validateEventTimes();
      locationValidator = validateLocation();
    });
    if (dateValidator != null || locationValidator != null) return false;
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      return true;
    } else {
      return false;
    }
  }

  Future<void> createEvent(EventRepository repository, User loggedUser) async {
    if (validateForm()) {
      Map<String, dynamic> locationData = {
        'name': selectedLocation.name,
        'latitude': selectedLocation.coordinates.latitude.toString(),
        'longitude': selectedLocation.coordinates.longitude.toString(),
      };
      Map<String, dynamic> eventData = {
        'title': eventTitleController.text,
        'description': eventDescriptionController.text,
        'is_private': isPrivateEvent,
        'needs_id': needsIdentification,
        'host_owner': loggedUser.username,
        'date_start':
            DateTime(
              selectedDateStart!.year,
              selectedDateStart!.month,
              selectedDateStart!.day,
              selectedTimeStart!.hour,
              selectedTimeStart!.minute,
            ).toIso8601String(),
        'date_closed':
            DateTime(
              selectedDateClosed!.year,
              selectedDateClosed!.month,
              selectedDateClosed!.day,
              selectedTimeClosed!.hour,
              selectedTimeClosed!.minute,
            ).toIso8601String(),
        'date_ended':
            DateTime(
              selectedDateEnded!.year,
              selectedDateEnded!.month,
              selectedDateEnded!.day,
              selectedTimeEnded!.hour,
              selectedTimeEnded!.minute,
            ).toIso8601String(),
        'seats':
            eventSeatsController.text.trim().isNotEmpty
                ? int.tryParse(eventSeatsController.text.trim())
                : -1,
        'price':
            isPaidEvent
                ? double.tryParse(eventPriceController.text.trim())
                : 0.0,
        'open_status': true,
        'tags': selectedTags,
      };
      try {
        await repository.createEvent(
          locationData,
          eventData,
          selectedThumbnail,
          selectedImages,
        );

        print("Event created");
      } catch (e) {
        throw Exception("Could not create event: $e");
      }
    }
  }

  String? validateEventTimes() {
    if (selectedDateStart == null ||
        selectedTimeStart == null ||
        selectedDateClosed == null ||
        selectedTimeClosed == null ||
        selectedDateEnded == null ||
        selectedTimeEnded == null) {
      return "Please select all dates and times.";
    }

    final start = DateTime(
      selectedDateStart!.year,
      selectedDateStart!.month,
      selectedDateStart!.day,
      selectedTimeStart!.hour,
      selectedTimeStart!.minute,
    );

    final close = DateTime(
      selectedDateClosed!.year,
      selectedDateClosed!.month,
      selectedDateClosed!.day,
      selectedTimeClosed!.hour,
      selectedTimeClosed!.minute,
    );

    final end = DateTime(
      selectedDateEnded!.year,
      selectedDateEnded!.month,
      selectedDateEnded!.day,
      selectedTimeEnded!.hour,
      selectedTimeEnded!.minute,
    );

    if (start.isBefore(DateTime.now())) {
      return "Start time cannot be in the past.";
    }

    if (close.isBefore(start)) {
      return "Close time must be after start time.";
    }

    if (end.isBefore(start)) {
      return "End time must be after start time.";
    }

    if (close.isAfter(end)) {
      return "Close time cannot be after end time.";
    }

    return null;
  }

  String? validateLocation() {
    if (selectedLocation.name.isEmpty &&
        selectedLocation.coordinates.longitude == 0 &&
        selectedLocation.coordinates.latitude == 0) {
      return "Please set event location";
    }
    return null;
  }

  void pickDate(
    Function(DateTime) updateDate,
    Function(TimeOfDay) updateTime,
  ) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() => updateDate(pickedDate));
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) setState(() => updateTime(pickedTime));
    }
  }

  void pickLocation(LatLng coordinates, String name) {
    setState(() {
      selectedLocation = selectedLocation.copyWith(
        coordinates: coordinates,
        name: name,
        timestamp: DateTime.now(),
      );
    });
  }

  Future<void> pickThumbnail() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final file = File(picked.path);
      final bytes = await file.length();
      const maxSize = 10 * 1024 * 1024;
      if (maxSize < bytes) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File too large. Max file size is 10MBs")),
        );
        return;
      }

      setState(() {
        selectedThumbnail = File(picked.path);
      });
    }
  }

  Future<void> pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles.isEmpty) return;

    const maxSize = 10 * 1024 * 1024;

    for (final picked in pickedFiles) {
      final file = File(picked.path);
      final bytes = await file.length();
      if (bytes > maxSize) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "One or more files exceed 10MB. Please select smaller files.",
            ),
          ),
        );
        return;
      }
    }

    setState(() {
      selectedImages = pickedFiles.map((e) => File(e.path)).toList();
    });
  }

  @override
  void dispose() {
    eventTitleController.dispose();
    eventDescriptionController.dispose();
    eventPriceController.dispose();
    eventSeatsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.read(eventRepositoryProvider);
    final loggedUser = ref.watch(loggedUserProvider).user;

    return Scaffold(
      appBar: AppBar(title: const Text("Create Event")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: GestureDetector(
                        onTap: pickThumbnail,
                        child:
                            selectedThumbnail != null
                                ? Container(
                                  width: double.infinity,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.file(
                                      selectedThumbnail!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                                : Container(
                                  padding: EdgeInsets.all(16),
                                  width: double.infinity,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.surfaceContainerHighest,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.image, size: 50),
                                      Text("Thumbnail"),
                                    ],
                                  ),
                                ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width:
                          selectedImages.isNotEmpty
                              ? MediaQuery.of(context).size.width *
                                  0.92 *
                                  selectedImages.length
                              : MediaQuery.of(context).size.width * 0.9,
                      child: GestureDetector(
                        onTap: pickImages,
                        child:
                            selectedImages.isNotEmpty
                                ? SizedBox(
                                  height: 300,
                                  child: ListView(
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    children:
                                        selectedImages.map((file) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              right: 12,
                                            ),
                                            child: Container(
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.9,
                                              height: 300,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                child: Image.file(
                                                  file,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                  ),
                                )
                                : Container(
                                  padding: const EdgeInsets.all(16),
                                  width: double.infinity,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.surfaceContainerHighest,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.collections, size: 50),
                                      Text("Add more images"),
                                    ],
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              FormTextWidget(
                controller: eventTitleController,
                label: "Title",
                icon: Icons.edit,
                maxLength: 20,
                validator: (value) {
                  if (value == null) {
                    return "Event must have a title";
                  }
                  if (value.isEmpty) {
                    return "Event must have a title";
                  }
                  return null;
                },
              ),
              FormTextWidget(
                controller: eventDescriptionController,
                label: "Description",
                icon: Icons.description,
                maxLength: 50,
                maxLines: 3,
              ),
              FormTextWidget(
                controller: eventSeatsController,
                keyboardType: TextInputType.number,
                label: "Seats (blank means infinite)",
                icon: Icons.event_seat,
                maxLength: 4,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 10),
              TagSelector(
                tags: eventTags,
                onSelectionChanged: (tags) {
                  setState(() {
                    selectedTags = tags;
                  });
                },
              ),
              _buildTitleSpacing("Event Dates"),
              _buildDateTimePicker(
                label: "Start",
                subtitle: Text("Event start time"),
                icon: Icons.event_available,
                date: selectedDateStart,
                time: selectedTimeStart,
                onTap:
                    () => pickDate(
                      (d) => selectedDateStart = d,
                      (t) => selectedTimeStart = t,
                    ),
              ),
              const SizedBox(height: 10),
              _buildDateTimePicker(
                label: "Close",
                subtitle: Text("Event close time: joining disabled."),
                icon: Icons.event_note,
                date: selectedDateClosed,
                time: selectedTimeClosed,
                onTap:
                    () => pickDate(
                      (d) => selectedDateClosed = d,
                      (t) => selectedTimeClosed = t,
                    ),
              ),
              const SizedBox(height: 10),
              _buildDateTimePicker(
                label: "End",
                subtitle: Text("Event end time"),
                icon: Icons.event_busy,
                date: selectedDateEnded,
                time: selectedTimeEnded,
                onTap:
                    () => pickDate(
                      (d) => selectedDateEnded = d,
                      (t) => selectedTimeEnded = t,
                    ),
              ),
              const SizedBox(height: 5),
              if (dateValidator != null)
                Text(
                  dateValidator!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              _buildTitleSpacing("Event Location"),
              _buildListTile(
                selectedLocation.name.isNotEmpty
                    ? selectedLocation.name
                    : "Location",
                selectedLocation.name.isNotEmpty
                    ? "${selectedLocation.coordinates.latitude.toStringAsFixed(3)},"
                        " ${selectedLocation.coordinates.longitude.toStringAsFixed(3)}"
                    : "Where will the event be",
                Icon(Icons.location_pin),
                IconButton(
                  icon: Icon(Icons.my_location, size: 30),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: _buildLocationPicker(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              if (locationValidator != null)
                Text(
                  locationValidator!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              _buildTitleSpacing("Event Status"),
              _buildListTile(
                isPrivateEvent ? "Private Event" : "Public Event",
                isPrivateEvent
                    ? "Only invited users can join."
                    : "Anyone can view and join.",
                isPrivateEvent
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
                Switch(
                  value: isPrivateEvent,
                  onChanged: (val) => setState(() => isPrivateEvent = val),
                ),
              ),
              const SizedBox(height: 10),
              _buildListTile(
                needsIdentification ? "ID required" : "Anyone allowed",
                needsIdentification
                    ? "Attendees need to provide ID"
                    : "Anyone can enter the event",
                needsIdentification ? Icon(Icons.badge) : Icon(Icons.public),
                Switch(
                  value: needsIdentification,
                  onChanged: (val) => setState(() => needsIdentification = val),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(isPaidEvent ? "Paid Event" : "Free Event"),
                      subtitle: Text(
                        isPaidEvent
                            ? "Entry is paid"
                            : "Entry is free of charge",
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(120),
                          fontSize: 12,
                        ),
                      ),
                      leading:
                          isPaidEvent
                              ? Icon(Icons.attach_money)
                              : Icon(Icons.money_off),
                      trailing: Switch(
                        value: isPaidEvent,
                        onChanged: (val) {
                          setState(() {
                            isPaidEvent = val;
                          });
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            final keyContext = _priceKey.currentContext;
                            if (keyContext != null) {
                              Scrollable.ensureVisible(
                                keyContext,
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.easeInOut,
                              );
                            }
                          });
                        },
                      ),
                    ),
                    if (isPaidEvent)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                          bottom: 8,
                        ),
                        child: FormTextWidget(
                          fieldKey: _priceKey,
                          keyboardType: TextInputType.number,
                          controller: eventPriceController,
                          label: "Price",
                          icon: Icons.monetization_on,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,2}$'),
                            ),
                          ],
                          validator: (value) {
                            final regex = RegExp(
                              r'^0|[1-9]\d*(\.\d{1,2})?$|^0\.[1-9]\d?$|^0\.0[1-9]$',
                            );
                            if (!regex.hasMatch(value!)) {
                              return 'Price is invalid';
                            }
                            if (double.parse(value) <= 0) {
                              return 'Price must be greater than zero';
                            }
                            if (double.parse(value) > 999) {
                              return "Price can't be this large";
                            }
                            return null;
                          },
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => createEvent(repository, loggedUser),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Create Event",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSpacing(String title) {
    return Column(
      children: [
        const SizedBox(height: 15),
        Text(title),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildListTile(
    String title,
    String subtitle,
    Icon leading,
    Widget trailing,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(25),
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(120),
            fontSize: 12,
          ),
        ),
        leading: leading,
        trailing: trailing,
      ),
    );
  }

  Widget _buildLocationPicker() {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 16, top: 4),
      child: Card(
        margin: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: EventLocationPicker(
            savedCoordinates: selectedLocation.coordinates,
            onLocationSelected:
                (coordinates, name) => pickLocation(coordinates, name),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimePicker({
    required String label,
    Widget? subtitle,
    required IconData icon,
    required DateTime? date,
    required TimeOfDay? time,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(25),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          date == null
              ? "$label Date"
              : "${DateFormat('dd/MM/yyyy').format(date)} at ${time != null ? time.format(context) : TimeOfDay.now().format(context)}",
        ),
        subtitle: subtitle,
        trailing: IconButton(
          icon: Icon(Icons.change_circle, size: 30),
          onPressed: onTap,
        ),
      ),
    );
  }
}
