import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keef_w_wen/data/constants.dart';
import 'package:keef_w_wen/views/widgets/tag_selector_widget.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final TextEditingController _eventTitleController = TextEditingController();
  final TextEditingController _eventDescriptionController =
      TextEditingController();
  DateTime? _selectedDateStart;
  DateTime? _selectedDateClosed;
  DateTime? _selectedDateEnd;
  TimeOfDay? _selectedTimeStart;
  TimeOfDay? _selectedTimeClosed;
  TimeOfDay? _selectedTimeEnd;
  String? _selectedThumbnailSrc;
  List<String>? _selectedImagesSrc;
  bool _isPrivate = false;
  final List<String> _tags = AppConstants.eventTags;

  void _pickDate(Function(DateTime) updateDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        updateDate(pickedDate);
      });
    }
  }

  void _pickTime(Function(TimeOfDay) updateTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        updateTime(pickedTime);
      });
    }
  }

  void _pickImage() async {
    AssetImage? imageSource = await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            height: 100,
            width: 100,
            child: Text("Picking an image...", style: TextStyle(fontSize: 24)),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Event")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _eventTitleController,
              maxLength: 20,
              decoration: InputDecoration(
                labelText: "Title",
                prefixIcon: Icon(Icons.edit),
              ),
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: _eventDescriptionController,
              decoration: InputDecoration(
                labelText: "Description",
                prefixIcon: Icon(Icons.description),
              ),
              maxLength: 50,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
            ),
            SizedBox(height: 10),
            TagSelector(tags: _tags, onSelectionChanged: (tag) {}),
            SizedBox(height: 10),
            Row(
              children: [
                Flexible(
                  child: ListTile(
                    title: Text(
                      _selectedDateStart == null
                          ? "Start Date"
                          : DateFormat(
                            'dd/MM/yyyy',
                          ).format(_selectedDateStart!),
                    ),
                    leading: Icon(Icons.event_available),
                    onTap: () => _pickDate((date) => _selectedDateStart = date),
                  ),
                ),
                Flexible(
                  child: ListTile(
                    title: Text(
                      _selectedTimeStart == null
                          ? "Start Time"
                          : _selectedTimeStart!.format(context),
                    ),
                    leading: Icon(Icons.access_time),
                    onTap: () => _pickTime((time) => _selectedTimeStart = time),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: ListTile(
                    title: Text(
                      _selectedDateClosed == null
                          ? "Close Date"
                          : DateFormat(
                            'dd/MM/yyyy',
                          ).format(_selectedDateClosed!),
                    ),
                    leading: Icon(Icons.event_note),
                    onTap:
                        () => _pickDate((date) => _selectedDateClosed = date),
                  ),
                ),
                Flexible(
                  child: ListTile(
                    title: Text(
                      _selectedTimeClosed == null
                          ? "Close Time"
                          : _selectedTimeClosed!.format(context),
                    ),
                    leading: Icon(Icons.access_time),
                    onTap:
                        () => _pickTime((time) => _selectedTimeClosed = time),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: ListTile(
                    title: Text(
                      _selectedDateEnd == null
                          ? "End Date"
                          : DateFormat('dd/MM/yyyy').format(_selectedDateEnd!),
                    ),
                    leading: Icon(Icons.event_busy),
                    onTap: () => _pickDate((date) => _selectedDateEnd = date),
                  ),
                ),
                Flexible(
                  child: ListTile(
                    title: Text(
                      _selectedTimeEnd == null
                          ? "End Time"
                          : _selectedTimeEnd!.format(context),
                    ),
                    leading: Icon(Icons.access_time),
                    onTap: () => _pickTime((time) => _selectedTimeEnd = time),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: ListTile(
                    title: Text("Thumbnail"),
                    leading: Icon(Icons.image),
                    onTap: _pickImage,
                  ),
                ),
                Flexible(
                  child: ListTile(
                    title: Text("Images"),
                    leading: Icon(Icons.collections),
                    onTap: _pickImage,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            SwitchListTile(
              title: Text("${_isPrivate ? "Private" : "Public"} Event"),
              subtitle: Text(
                _isPrivate
                    ? "Private events require invites to add participants."
                    : " Public events can be viewed by anyone.",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
                  fontSize: 12,
                ),
              ),
              value: _isPrivate,
              onChanged: (value) {
                setState(() {
                  _isPrivate = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Center(child: Text("Create Event")),
            ),
          ],
        ),
      ),
    );
  }
}
