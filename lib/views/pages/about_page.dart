import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("About Keef w Wen")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Keef w Wen",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Keef w Wen is a social event platform designed to help people host, discover, and join events in real-time. It allows authenticated users to organize private or public gatherings, share their locations, and interact securely.",
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.verified_user_outlined),
              title: const Text("Version"),
              subtitle: const Text("1.0.0"),
            ),
            ListTile(
              leading: const Icon(Icons.build_outlined),
              title: const Text("Technologies Used"),
              subtitle: const Text(
                "Flutter, Django, PostgreSQL, Android Studio",
              ),
            ),
            ListTile(
              leading: const Icon(Icons.groups_outlined),
              title: const Text("Developed by"),
              subtitle: const Text("Mhmd Bakkour"),
            ),
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text("Contact"),
              subtitle: const Text("anas.bakkour@hotmail.com"),
            ),
          ],
        ),
      ),
    );
  }
}
