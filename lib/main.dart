import 'package:flutter/material.dart';
import 'package:tic_tac_game/widgets/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF003C43),
        shadowColor: const Color(0xFF135D66),
        splashColor: const Color(0xFF77B0AA),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
