import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/classes/providers.dart';
import 'package:keef_w_wen/views/pages/events_page.dart';
import 'package:keef_w_wen/views/pages/home_page.dart';
import 'package:keef_w_wen/views/pages/login_page.dart';
import 'package:keef_w_wen/views/pages/map_page.dart';
import 'package:keef_w_wen/views/pages/people_page.dart';
import 'package:keef_w_wen/views/pages/profile_page.dart';
import 'package:keef_w_wen/views/pages/settings_page.dart';
import 'package:keef_w_wen/views/widgets/navbar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/constants.dart';
import '../data/notifiers.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<MainView> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  @override
  void initState() {
    super.initState();
    // Fetch data once at init
    Future.microtask(() {
      ref.read(eventProvider.notifier).fetchEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(eventProvider);
    final userState = ref.watch(userProvider);
    final loggedUser = ref.read(loggedUserProvider).user;

    if (eventState.isLoading || userState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final pages = [
      HomePage(),
      EventsPage(),
      MapPage(),
      PeoplePage(),
      ProfilePage(),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          selectedPageNotifier.value = 0;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: ValueListenableBuilder(
            valueListenable: selectedPageNotifier,
            builder: (context, value, child) {
              return value == 4
                  ? Text(
                    loggedUser.username.isNotEmpty
                        ? loggedUser.username
                        : "Profile",
                  )
                  : Text("Keef W Wen");
            },
          ),
          actions: [
            ValueListenableBuilder(
              valueListenable: isDarkModeNotifier,
              builder: (context, isDarkMode, child) {
                return IconButton(
                  onPressed: () async {
                    isDarkModeNotifier.value = !isDarkMode;
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool(AppConstants.themeModeKey, !isDarkMode);
                  },
                  icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
                );
              },
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
              icon: Icon(Icons.settings),
            ),
          ],
        ),
        body: ValueListenableBuilder(
          valueListenable: selectedPageNotifier,
          builder: (context, value, child) {
            return pages.elementAt(value);
          },
        ),
        floatingActionButton: ValueListenableBuilder<int>(
          valueListenable: selectedPageNotifier,
          builder: (context, value, _) {
            if (value == 4) {
              return FloatingActionButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Icon(Icons.logout),
              );
            } else {
              return SizedBox.shrink(); // empty invisible widget
            }
          },
        ),
        bottomNavigationBar: NavbarWidget(),
      ),
    );
  }
}
