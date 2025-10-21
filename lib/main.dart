import 'package:shared_preferences/shared_preferences.dart';
import 'package:wokadia/feature/home/home.dart';
import 'package:wokadia/feature/splashcreen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? name = prefs.getString('name');
  runApp( MyApp(name:name));
}

class MyApp extends StatefulWidget {

  String? name;

  MyApp({Key? key, required this.name}):super(key:key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wokadia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
     // home:  SplashScreen(),
      home: (widget.name != null && widget.name!.isNotEmpty)
          ? HomePage()
          : SplashScreen(),

    );
  }
}
