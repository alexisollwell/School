import 'package:flutter/material.dart';
import 'package:school/views/access/load/load.dart';

import 'views/MainMenu/pages/carga masiva/cargamasiva.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xochicalco',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const Load(),
    );
  }
}
