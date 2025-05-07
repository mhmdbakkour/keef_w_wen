import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keef_w_wen/classes/providers.dart';
import 'package:keef_w_wen/classes/repositories/user_repository.dart';
import 'package:keef_w_wen/views/pages/login_page.dart';
import 'dart:io';
import '../../services/phone_formatter.dart';
import '../widgets/form_text_widget.dart';

class RegisterDetailsPage extends ConsumerStatefulWidget {
  const RegisterDetailsPage({super.key, required this.requiredUserData});

  final Map<String, dynamic> requiredUserData;

  @override
  ConsumerState<RegisterDetailsPage> createState() =>
      _OptionalDetailsPageState();
}

class _OptionalDetailsPageState extends ConsumerState<RegisterDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController controllerFullname = TextEditingController();
  final TextEditingController controllerMobileNumber = TextEditingController();
  final TextEditingController controllerBio = TextEditingController();

  final FocusNode fullNameNode = FocusNode();
  final FocusNode mobileNumberNode = FocusNode();
  final FocusNode bioNode = FocusNode();
  final FocusNode locationNode = FocusNode();

  bool sharingLocation = false;

  File? profileImage;

  Future<void> pickImage() async {
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
        profileImage = File(picked.path);
      });
    }
  }

  Future<void> submitDetails(UserRepository repository, bool hasSkipped) async {
    Map<String, dynamic> allUserData = widget.requiredUserData;
    if (!hasSkipped) {
      Map<String, dynamic> extraUserData = {
        'fullname': controllerFullname.text.trim(),
        'bio': controllerBio.text.trim(),
        'mobile_number':
            '+961${controllerMobileNumber.text.replaceAll(RegExp(r'\D'), '')}',
        'sharing_location': sharingLocation,
      };
      allUserData.addAll(extraUserData);
      if (_formKey.currentState?.validate() ?? false) {
        _formKey.currentState?.save();
        await repository.register(allUserData, profileImage);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } else {
      await repository.register(allUserData, profileImage);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.read(userRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Continue registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: pickImage,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage:
                          profileImage != null
                              ? FileImage(profileImage!)
                              : null,
                      child:
                          profileImage == null
                              ? const Icon(Icons.camera_alt, size: 40)
                              : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FormTextWidget(
                  label: 'Full Name',
                  icon: Icons.edit,
                  controller: controllerFullname,
                  focusNode: fullNameNode,
                  focusNodeNext: mobileNumberNode,
                  maxLength: 24,
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: controllerMobileNumber,
                  focusNode: mobileNumberNode,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    PhoneFormatter(),
                  ],
                  autovalidateMode: AutovalidateMode.onUnfocus,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    prefixText: '+961 ',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  validator: (value) {
                    final digitsOnly =
                        value?.replaceAll(RegExp(r'\D'), '') ?? '';
                    final regex = RegExp(r'^(03|71|73|76|78|79|81)\d{6}$');
                    if (!regex.hasMatch(digitsOnly)) {
                      return 'Invalid phone number';
                    }
                    if (digitsOnly.length < 8) return 'Invalid phone number';
                    return null;
                  },
                  onFieldSubmitted:
                      (_) => FocusScope.of(context).requestFocus(bioNode),
                ),
                FormTextWidget(
                  label: "Bio",
                  controller: controllerBio,
                  icon: Icons.article,
                  focusNode: bioNode,
                  focusNodeNext: locationNode,
                  maxLines: 4,
                  maxLength: 100,
                ),
                SwitchListTile(
                  focusNode: locationNode,
                  title: Text("Share location"),
                  value: sharingLocation,
                  onChanged: (value) {
                    setState(() {
                      sharingLocation = !sharingLocation;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    try {
                      submitDetails(repository, false);
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("User updated")));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed to update user")),
                      );
                    }
                  },
                  child: const Text('Complete registration'),
                ),
                TextButton(
                  onPressed: () {
                    try {
                      submitDetails(repository, true);
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("User updated")));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed to update user")),
                      );
                    }
                  },
                  child: const Text('Skip for now'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
