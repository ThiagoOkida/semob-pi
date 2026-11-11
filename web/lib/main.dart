import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'features/login_page.dart';

void main() => runApp(const SemobApp());

class SemobApp extends StatelessWidget {
  const SemobApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'SEMOB · Painel de Operação',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: const LoginPage(),
      );
}