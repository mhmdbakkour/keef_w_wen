import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController controller = TextEditingController();
  bool? isChecked = false;
  bool isSwitched = false;
  double sliderVal = 0.0;
  String? menuItem = 'e1';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SettingsPage();
                },
              ),
            );
          },
          icon: Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton(
              value: menuItem,
              items: [
                DropdownMenuItem(value: 'e1', child: Text("Element 1")),
                DropdownMenuItem(value: 'e2', child: Text("Element 2")),
                DropdownMenuItem(value: 'e3', child: Text("Element 3")),
              ],
              onChanged: (String? value) {
                setState(() {
                  menuItem = value;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(border: OutlineInputBorder()),
                onEditingComplete: () => setState(() {}),
              ),
            ),
            Text(controller.text),
            Switch(
              value: isSwitched,
              onChanged: (bool value) {
                setState(() {
                  isSwitched = value;
                });
              },
            ),
            SwitchListTile(
              title: Text("You are amazing!"),
              value: isSwitched,
              onChanged: (bool value) {
                setState(() {
                  isSwitched = value;
                });
              },
            ),
            Slider(
              value: sliderVal,
              divisions: 4,
              onChanged: (double value) {
                setState(() {
                  sliderVal = value;
                });
              },
            ),
            GestureDetector(
              onTap: () {
                print("IMAGE!");
              },
              child: Container(
                height: 50,
                width: double.infinity,
                color: Colors.white12,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Snackbar!"),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text("Open snack bar"),
            ),
            FilledButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Alert!"),
                      content: Text("Alert content.."),
                      actions: [
                        FilledButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Close"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text("Open dialog"),
            ),
            TextButton(onPressed: () {}, child: Text("Text Button")),
            OutlinedButton(onPressed: () {}, child: Text("Outlined Button")),
            CloseButton(),
            BackButton(),
          ],
        ),
      ),
    );
  }
}
