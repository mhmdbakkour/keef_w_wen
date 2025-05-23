import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/data/notifiers.dart';
import 'package:keef_w_wen/views/pages/about_page.dart';
import 'package:keef_w_wen/views/pages/edit_user_page.dart';
import 'package:keef_w_wen/views/pages/login_page.dart';
import 'package:keef_w_wen/views/pages/privacy_policy_page.dart';
import 'package:keef_w_wen/views/pages/terms_of_service_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../classes/providers.dart';
import '../../data/constants.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool isSharingLocation = false;
  bool showsName = true;
  bool isProfilePrivate = false;
  bool autoJoins = false;
  bool canNotify = true;

  @override
  void initState() {
    super.initState();
    final loggedUser = ref.read(loggedUserProvider).user;
    isSharingLocation = loggedUser.sharingLocation;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final loggedUser = ref.watch(loggedUserProvider).user;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: ListView(
            children: [
              _sectionHeader('Account'),
              _roundedTile(
                icon: Icons.person,
                iconColor: primaryColor,
                title: 'Edit Profile',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditUserPage()),
                  );
                },
              ),
              _roundedTile(
                icon: Icons.lock,
                iconColor: primaryColor,
                title: 'Change Password',
                onTap: () {},
              ),
              _roundedTile(
                icon: Icons.delete,
                iconColor: primaryColor,
                title: 'Delete Account',
                onTap: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: Theme.of(context).colorScheme.error,
                                size: 28,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Delete Account?",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "This action is permanent and irreversible.",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                "All your events, followers, and data will be erased from our servers. "
                                "You will not be able to recover your account or any of its contents.\n\n"
                                "This cannot be undone.",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          actionsAlignment: MainAxisAlignment.center,
                          actions: [
                            FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                              ),
                              onPressed: () {
                                ref
                                    .read(loggedUserProvider.notifier)
                                    .deleteUser(loggedUser.username);
                                showModalBottomSheet(
                                  context: context,
                                  builder:
                                      (context) =>
                                          Text("Account successfully removed"),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                );
                              },
                              icon: Icon(Icons.delete_forever),
                              label: Text("Yes, delete it"),
                            ),
                          ],
                        ),
                  );
                },
              ),

              _sectionHeader('Privacy'),
              _toggleTile(
                'Location Sharing',
                isSharingLocation,
                Icons.share_location,
                primaryColor,
                (val) {
                  setState(() {
                    isSharingLocation = !isSharingLocation;
                    loggedUser.sharingLocation = val;
                  });
                },
              ),
              _toggleTile(
                'Show My Name in Events',
                showsName,
                Icons.visibility,
                primaryColor,
                (val) {
                  setState(() {
                    showsName = !showsName;
                  });
                },
              ),
              _toggleTile(
                'Make Profile Private',
                isProfilePrivate,
                Icons.privacy_tip,
                primaryColor,
                (val) {
                  setState(() {
                    isProfilePrivate = !isProfilePrivate;
                  });
                },
              ),
              _roundedTile(
                icon: Icons.block,
                iconColor: primaryColor,
                title: 'Blocked Users',
                onTap: () {},
              ),

              _sectionHeader('Event Preferences'),
              _toggleTile(
                'Auto-Join Nearby Public Events',
                autoJoins,
                Icons.join_full,
                primaryColor,
                (val) {
                  setState(() {
                    autoJoins = !autoJoins;
                  });
                },
              ),
              _toggleTile(
                'Notify When Friends Create Events',
                canNotify,
                Icons.notification_important,
                primaryColor,
                (val) {
                  setState(() {
                    canNotify = !canNotify;
                  });
                },
              ),
              _roundedTile(
                icon: Icons.event_available,
                iconColor: primaryColor,
                title: 'Manage Saved Events',
                onTap: () {},
              ),

              _sectionHeader('App Customization'),
              ValueListenableBuilder(
                valueListenable: isDarkModeNotifier,
                builder: (context, isDarkMode, child) {
                  return _toggleTile(
                    'Dark Mode',
                    isDarkModeNotifier.value,
                    Icons.dark_mode,
                    primaryColor,
                    (val) async {
                      isDarkModeNotifier.value = !isDarkMode;
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setBool(
                        AppConstants.themeModeKey,
                        !isDarkMode,
                      );
                    },
                  );
                },
              ),

              _roundedTile(
                icon: Icons.translate,
                iconColor: primaryColor,
                title: 'Language',
                subtitle: 'English',
                onTap: () {},
              ),

              _sectionHeader('Support & Info'),
              _roundedTile(
                icon: Icons.info_outline,
                iconColor: primaryColor,
                title: 'About Keef w Wen',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutPage()),
                  );
                },
              ),
              _roundedTile(
                icon: Icons.security,
                iconColor: primaryColor,
                title: 'Privacy Policy',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrivacyPolicyPage(),
                    ),
                  );
                },
              ),
              _roundedTile(
                icon: Icons.home_repair_service,
                iconColor: primaryColor,
                title: 'Terms of Service',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TermsOfServicePage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 8, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _roundedTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? Colors.red),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _toggleTile(
    String title,
    bool value,
    IconData icon,
    Color? iconColor,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          leading: Icon(icon, color: iconColor ?? Colors.red),
          title: Text(title),
          trailing: Switch(value: value, onChanged: onChanged),
        ),
      ),
    );
  }
}
