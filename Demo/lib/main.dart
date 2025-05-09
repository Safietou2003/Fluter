import 'package:flutter/material.dart';
import 'views/inscription/inscription_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des Inscriptions',
      home: const InscriptionView(),
    );
  }
}