import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

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
                onTap: () {},
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
                onTap: () {},
              ),

              _sectionHeader('Privacy'),
              _toggleTile(
                'Location Sharing',
                true,
                Icons.share_location,
                primaryColor,
                (val) {},
              ),
              _toggleTile(
                'Show My Name in Events',
                true,
                Icons.visibility,
                primaryColor,
                (val) {},
              ),
              _toggleTile(
                'Make Profile Private',
                false,
                Icons.privacy_tip,
                primaryColor,
                (val) {},
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
                false,
                Icons.join_full,
                primaryColor,
                (val) {},
              ),
              _toggleTile(
                'Notify When Friends Create Events',
                true,
                Icons.notification_important,
                primaryColor,
                (val) {},
              ),
              _roundedTile(
                icon: Icons.event_available,
                iconColor: primaryColor,
                title: 'Manage Saved Events',
                onTap: () {},
              ),

              _sectionHeader('App Customization'),
              _toggleTile(
                'Dark Mode',
                false,
                Icons.dark_mode,
                primaryColor,
                (val) {},
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
                onTap: () {},
              ),
              _roundedTile(
                icon: Icons.security,
                iconColor: primaryColor,
                title: 'Privacy Policy',
                onTap: () {},
              ),
              _roundedTile(
                icon: Icons.help_outline,
                iconColor: primaryColor,
                title: 'Contact Support',
                onTap: () {},
              ),

              const SizedBox(height: 20),
              Center(
                child: FilledButton.icon(
                  onPressed: () {
                    // Handle logout
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                ),
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
