import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/data/notifiers.dart';
import 'package:keef_w_wen/theme.dart';
import 'package:keef_w_wen/views/main_view.dart';
import 'package:keef_w_wen/views/pages/login_page.dart';
import 'package:keef_w_wen/data/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initThemeMode();
    super.initState();
  }

  void initThemeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? themeMode = prefs.getBool(AppConstants.themeModeKey);
    isDarkModeNotifier.value = themeMode ?? true;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          routes: {"/main": (context) => MainView()},
          themeMode:
              isDarkModeNotifier.value ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          theme: AppTheme(Typography.blackRedmond).light(),
          darkTheme: AppTheme(Typography.blackRedwoodCity).dark(),
          home: LoginPage(),
        );
      },
    );
  }
}
