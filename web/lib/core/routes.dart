import 'package:flutter/material.dart';
import '../features/conferencia_page.dart';
import '../features/demanda_page.dart';
import '../features/home_page.dart';
import '../features/importacao_page.dart';
import '../features/login_page.dart';
import '../features/ocorrencia_page.dart';
import '../features/quilometragem_page.dart';
import '../features/receitas_page.dart';
import '../features/tv_page.dart';
import '../features/usuarios_page.dart';

/// Rotas nomeadas do painel. Quando o back-end existir, é aqui que entra a
/// verificação de sessão (redirecionar para /login se não houver token).
Route<dynamic> generateRoute(RouteSettings s) {
  final Widget page;
  switch (s.name) {
    case '/visao-geral':
      page = const HomePage();
      break;
    case '/demanda':
      page = const DemandaPage();
      break;
    case '/receita':
      page = const ReceitasPage();
      break;
    case '/quilometragem':
      page = const QuilometragemPage();
      break;
    case '/ocorrencias':
      page = const OcorrenciaPage();
      break;
    case '/conferencia':
      page = const ConferenciaPage();
      break;
    case '/importacoes':
      page = const ImportacaoPage();
      break;
    case '/usuarios':
      page = const UsuariosPage();
      break;
    case '/tv':
      page = const TvPage();
      break;
    default:
      page = const LoginPage();
  }
  return PageRouteBuilder<void>(
    settings: s,
    pageBuilder: (_, __, ___) => page,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
  );
}
