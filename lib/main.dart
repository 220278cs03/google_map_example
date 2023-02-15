import 'package:flutter/material.dart';
import 'package:google_map_usage/controller/main_controller.dart';
import 'package:google_map_usage/view/pages/view_map.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainController())
      ],
      child: const MaterialApp(
        home: ViewMap(),
      ),
    );
  }
}
