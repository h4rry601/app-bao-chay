import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:myapp/firebase_options.dart';
import 'package:provider/provider.dart';
import 'provider/theme_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.subscribeToTopic("sample");

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'GSafe Smart Alert',
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            primarySwatch: Colors.red,
            brightness: Brightness.light,
            fontFamily: 'Roboto',
            textTheme: const TextTheme(
              bodyLarge: TextStyle(fontSize: 16.0),
              bodyMedium: TextStyle(fontSize: 14.0),
              titleLarge:
                  TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.red,
            brightness: Brightness.dark,
            fontFamily: 'Roboto',
            textTheme: const TextTheme(
              bodyLarge: TextStyle(fontSize: 16.0, color: Colors.white70),
              bodyMedium: TextStyle(fontSize: 14.0, color: Colors.white70),
              titleLarge: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          home: const SplashScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
