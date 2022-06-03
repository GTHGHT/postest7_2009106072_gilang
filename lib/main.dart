import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../utils/bottom_navbar_index.dart';
import '../utils/settings_notifier.dart';
import '../pages/landing_page.dart';
import 'package:provider/provider.dart';

import '../utils/theme_notifier.dart';
import 'firebase_options.dart';
import 'utils/forecast_notifier.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ForecastNotifier>(
          create:(_) => ForecastNotifier(),
        ),
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(),
        ),
        ChangeNotifierProvider<BottomNavBarIndex>(
          create: (_) => BottomNavBarIndex(),
        ),
        ChangeNotifierProvider<SettingsNotifier>(
          create: (_) => SettingsNotifier(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blueAccent,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.greenAccent,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            primary: Colors.greenAccent,
          ),
        ),
      ),
      themeMode: context.watch<ThemeNotifier>().themeMode,
      home: DefaultTextStyle(
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white,
        ),
        child: const LandingPage(),
      ),
    );
  }
}