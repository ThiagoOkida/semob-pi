import 'package:flutter/material.dart';
import 'core/routes.dart';
import 'core/theme.dart';

void main() => runApp(const SemobApp());

class SemobApp extends StatelessWidget {
  const SemobApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SEMOB · Painel de Operação',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      initialRoute: '/login',
      onGenerateRoute: generateRoute,
    );
  }
}