import 'dart:math';
import '../core/format.dart';

/// Dados de exemplo no mesmo formato dos relatórios da operadora.
/// Quando o back-end existir, este arquivo é substituído por um repositório
/// que lê da API; as telas continuam iguais.

class Kpi {
  const Kpi(this.label, this.value, this.sub, {this.unit, this.of, this.conferido = true});
  final String label, value, sub;
  final String? unit, of;
  final bool conferido;
}

class _Rng {
  _Rng(this._s);
  int _s;
  double next() {
    _s = (_s * 48271) % 2147483647;
    return _s / 2147483647;
  }
}

// ---------------- Visão geral ----------------
const kpisVisaoGeral = [
  Kpi('Quilometragem produtiva', '60.039,6', '+7,7% sobre 01 a 07/09', unit: 'km'),
  Kpi('Viagens realizadas', '8.029', '99,9% do programado', of: 'de 8.034'),
  Kpi('Passageiros pagantes', '61.265', '+12,9% sobre 01 a 07/09'),
  Kpi('Gratuidades', '174.900', '+8,8% sobre 01 a 07/09'),
  Kpi('Total de passageiros', '236.165', '+9,8% sobre 01 a 07/09'),
];

const regrasResumo = [
  'Viagens e km do resumo diário',
  'Programadas menos realizadas e ocorrências',
  'Turnos somam o total do dia',
  'Resumo por linha e viagens',
  'Uso de créditos e tarifa',
];

// ---------------- Demanda ----------------
class DayPoint {
  const DayPoint(this.date, this.total, this.free, this.paid);
  final DateTime date;
  final double total, free, paid; // em milhares
}

List<DayPoint> _buildDemanda() {
  final r = _Rng(7);
  final out = <DayPoint>[];
  var d = DateTime(2026, 8, 3);
  final end = DateTime(2026, 9, 11);
  while (!d.isAfter(end)) {
    final feriado = d.month == 9 && d.day == 7;
    if (d.weekday <= 5 && !feriado) {
      final i = out.length;
      var total = 44.0 +
          sin(i / 2.3) * 2.2 +
          (d.weekday == 1 ? -3.0 : 0.0) +
          (d.weekday == 5 ? -1.2 : 0.0) +
          (r.next() - .5) * 2.2;
      if (d.month == 9 && d.day == 10) total = 39.5;
      final paid = 12.0 + (r.next() - .5) * 1.4;
      out.add(DayPoint(d, total, total - paid, paid));
    }
    d = DateTime(d.year, d.month, d.day + 1);
  }
  return out;
}

final List<DayPoint> demandaDiaria = _buildDemanda();

const compararQuintas = [
  ('06/08', 41562),
  ('13/08', 44151),
  ('20/08', 46149),
  ('27/08', 47112),
  ('03/09', 47635),
  ('10/09', 39479),
];

// ---------------- Receita ----------------
class ReceitaDia {
  const ReceitaDia(this.date, this.catraca, this.antecipada);
  final DateTime date;
  final double catraca, antecipada; // em milhares de reais
}

List<ReceitaDia> _buildReceita() {
  final r = _Rng(11);
  const picos = <String, double>{'25/08': 138, '26/08': 50, '27/08': 76, '28/08': 100, '31/08': 20};
  final out = <ReceitaDia>[];
  var d = DateTime(2026, 8, 17);
  final end = DateTime(2026, 9, 14);
  while (!d.isAfter(end)) {
    final fds = d.weekday >= 6;
    final key = '${two(d.day)}/${two(d.month)}';
    final catraca = fds ? 9.0 + r.next() * 12 : 40.0 + r.next() * 5;
    var antec = fds ? 1.0 + r.next() * 4 : 8.0 + r.next() * 28;
    if (picos.containsKey(key)) antec = picos[key]!;
    out.add(ReceitaDia(d, catraca, antec));
    d = DateTime(d.year, d.month, d.day + 1);
  }
  return out;
}

final List<ReceitaDia> receitaDiaria = _buildReceita();

List<double> _interp(List<double> pts, int n) {
  return List.generate(n, (i) {
    final t = i / (n - 1) * (pts.length - 1);
    final a = min(t.floor(), pts.length - 2);
    final f = t - a;
    return pts[a] + (pts[a + 1] - pts[a]) * f;
  });
}

/// Crédito circulante de 15/07 a 14/09, em milhares de reais.
final List<double> creditoCirculante = _interp(
  [10, 20, 130, 270, 330, 480, 490, 520, 510, 500, 485, 520, 560, 550, 780, 830, 830, 820, 800, 790],
  62,
);

const kpisReceita = [
  Kpi('Receita de catraca (estimada)', 'R\$ 218.900', '+12,2% sobre 01 a 07/09.\nPassageiros de catraca × R\$ 5,00', conferido: false),
  Kpi('Venda antecipada', 'R\$ 44.185', '−4,7% sobre 01 a 07/09', conferido: false),
  Kpi('Uso de créditos', 'R\$ 87.425', 'Antecipados × tarifa'),
  Kpi('Crédito circulante', 'R\$ 794.090', 'Cerca de 70,9 dias de uso', conferido: false),
];

// ---------------- Quilometragem ----------------
class LinhaKm {
  const LinhaKm(this.code, this.nome, this.viagens, this.km);
  final String code, nome;
  final int viagens;
  final double km;
}

const linhasKm = [
  LinhaKm('01', 'Santa Maria / Estação', 3427, 22753.9),
  LinhaKm('02', 'Circular Gerty / ParkShopping / Fund...', 5841, 47042.5),
  LinhaKm('03', 'Barcelona Circular', 5848, 45189.3),
  LinhaKm('04', 'Santa Paula / Estação', 3344, 29215.1),
  LinhaKm('05', 'Bairro Mauá / Estação', 3387, 29565.4),
  LinhaKm('06', 'Nova Gerty / Estação', 4496, 30754.0),
  LinhaKm('07', 'Boa Vista / Estação', 3556, 24864.6),
  LinhaKm('08', 'Prosperidade / Estação via Fund...', 1676, 11197.7),
  LinhaKm('10', 'Oswaldo Cruz / Estação', 3419, 21304.3),
];

const kpisKm = [
  Kpi('Km produtivo', '261.886,8', '+5,5% sobre julho', unit: 'km'),
  Kpi('Km improdutivo', '13.807,7', '5,0% do total. Não remunerado', unit: 'km', conferido: false),
  Kpi('Viagens realizadas', '34.994', '99,84% do programado', of: 'de 35.050'),
  Kpi('Km médio por viagem', '7,48', 'Todas as linhas', unit: 'km', conferido: false),
];

// ---------------- Ocorrências ----------------
class Ocorrencia {
  const Ocorrencia(this.data, this.linha, this.nome, this.situacao, this.horario);
  final String data, linha, nome, situacao, horario;
}

const ocorrencias = [
  Ocorrencia('11/09/2026', '03', 'Barcelona Circular', 'Não realizada', '17:19'),
  Ocorrencia('11/09/2026', '03', 'Barcelona Circular', 'Não realizada', '16:44'),
  Ocorrencia('10/09/2026', '03', 'Barcelona Circular', 'Não realizada', '11:40'),
  Ocorrencia('10/09/2026', '06', 'Nova Gerty / Estação', 'Não realizada', '23:55'),
  Ocorrencia('10/09/2026', '06', 'Nova Gerty / Estação', 'Não terminada', '23:20'),
  Ocorrencia('03/09/2026', '02', 'Circular Gerty / ParkShopping', 'Não realizada', '20:48'),
  Ocorrencia('02/09/2026', '02', 'Circular Gerty / ParkShopping', 'Não realizada', '19:28'),
  Ocorrencia('02/09/2026', '06', 'Nova Gerty / Estação', 'Não realizada', '18:08'),
  Ocorrencia('02/09/2026', '07', 'Boa Vista / Estação', 'Não realizada', '14:20'),
];

// ---------------- Conferência ----------------
class Regra {
  const Regra(this.titulo, this.detalhe, {this.pendente = false});
  final String titulo, detalhe;
  final bool pendente;
}

const regrasConferencia = [
  Regra('Viagens e km do resumo diário batem com o arquivo de viagens', '62 de 62 dias'),
  Regra('Programadas menos realizadas batem com as ocorrências registradas', '62 de 62 dias'),
  Regra('Manhã, tarde e noite somam o total do dia', '62 de 62 dias'),
  Regra('Resumo por linha bate com as viagens agrupadas', 'Todos os dias e linhas'),
  Regra('Uso de créditos bate com passageiros antecipados vezes a tarifa', '62 de 62 dias'),
  Regra('Dias com operação e passageiros registrados', 'Faltam passageiros de 01 a 14/07', pendente: true),
];

// ---------------- Importações ----------------
class ImportacaoItem {
  ImportacaoItem(this.arquivo, this.tipo, this.periodo, this.registros, this.situacao, [this.por]);
  final String arquivo, tipo, periodo, registros;
  String situacao; // Pendente | Aprovada | Rejeitada
  String? por;
}

List<ImportacaoItem> importacoesIniciais() => [
      ImportacaoItem('Quinzenal_Viagens_202609.html', 'Viagens', '01 a 14/09/2026', '16.280', 'Pendente'),
      ImportacaoItem('Quinzenal_202609.html', 'Resumo geral', '01 a 14/09/2026', '14', 'Pendente'),
      ImportacaoItem('Passageiros_Quinzenal.html', 'Passageiros', '01 a 14/09/2026', '14', 'Pendente'),
      ImportacaoItem('Saldos_Quinzenal.html', 'Saldos', '01 a 14/09/2026', '28', 'Pendente'),
      ImportacaoItem('Quinzenal_Viag_NRealiz_202609.html', 'Não realizadas', '01 a 14/09/2026', '8', 'Pendente'),
      ImportacaoItem('Mensal_202608.html', 'Resumo geral', '01 a 31/08/2026', '31', 'Aprovada', 'M. Pante'),
      ImportacaoItem('Mensal_FCV_202608.html', 'Cumprimento', '01 a 31/08/2026', '93', 'Aprovada', 'M. Pante'),
    ];

// ---------------- Usuários ----------------
class Usuario {
  Usuario(this.nome, this.email, this.perfil, this.ativo);
  final String nome, email, perfil;
  final bool ativo;
}

List<Usuario> usuariosIniciais() => [
      Usuario('Marcelo Pante', 'marcelo.pante@semob.exemplo', 'Administrador', true),
      Usuario('Analista de fiscalização', 'fiscalizacao@semob.exemplo', 'Usuário', true),
      Usuario('Gabinete do secretário', 'gabinete@semob.exemplo', 'Usuário', false),
    ];

// ---------------- Modo TV ----------------
class TvCard {
  const TvCard(this.label, this.value, this.sub, [this.kind = 'neutral']);
  final String label, value, sub, kind; // kind: ok | warn | bad | neutral
}

class TvAlert {
  const TvAlert(this.title, this.text, this.kind);
  final String title, text, kind;
}

class TvSlide {
  const TvSlide(this.nome, this.titulo, this.cards, this.graficoTitulo, this.legenda, this.alertas, this.seed, this.base);
  final String nome, titulo, graficoTitulo, legenda;
  final List<TvCard> cards;
  final List<TvAlert> alertas;
  final int seed;
  final double base;
}

List<double> tvSerie(int seed, double base) {
  final r = _Rng(seed);
  return List.generate(42, (i) {
    final dow = i % 7;
    final fator = dow < 5 ? 1.0 : (dow == 5 ? 0.62 : 0.42);
    return base * fator * (0.95 + r.next() * 0.1);
  });
}

const tvSlides = [
  TvSlide(
    'Visão geral',
    'Visão geral da operação',
    [
      TvCard('Passageiros', '236.165', '+9,6% vs semana anterior', 'ok'),
      TvCard('Pagantes', '61.265', '+12,9%', 'ok'),
      TvCard('Gratuidades', '174.900', '+8,8%', 'ok'),
      TvCard('Km produtivo', '60.039', '+7,7%', 'ok'),
      TvCard('Viagens realizadas', '99,9%', '8.029 de 8.034 programadas', 'ok'),
    ],
    'Demanda diária · últimas 6 semanas',
    'Passageiros (mil)',
    [
      TvAlert('Linha 03', '3 viagens perdidas hoje', 'bad'),
      TvAlert('Linha 07', 'Ocorrência aberta de veículo · 13:58', 'warn'),
      TvAlert('Conferência', '2 divergências de km pendentes', 'warn'),
      TvAlert('Linha 05', 'Pontualidade de 88% no pico da manhã', 'ok'),
    ],
    3,
    44,
  ),
  TvSlide(
    'Demanda',
    'Demanda de passageiros',
    [
      TvCard('Passageiros hoje', '41.540', '+4,1% vs média', 'ok'),
      TvCard('Pico da manhã', '6.912', '06h às 08h'),
      TvCard('Pagantes', '26%', '19.058 passageiros'),
      TvCard('Gratuidades', '74%', '39.749 passageiros'),
      TvCard('Linha mais cheia', '07', '5.329 passageiros', 'warn'),
    ],
    'Passageiros por dia · últimas 6 semanas',
    'Passageiros (mil)',
    [
      TvAlert('Linha 07', 'Lotação acima de 98% no pico', 'warn'),
      TvAlert('Linha 03', 'Demanda 18% abaixo da média', 'warn'),
      TvAlert('Terminal', 'Fila no ponto central às 8h', 'warn'),
      TvAlert('Linha 05', 'Gratuidades +12% hoje', 'ok'),
    ],
    5,
    42,
  ),
  TvSlide(
    'Quilometragem',
    'Quilometragem da frota',
    [
      TvCard('Km programado', '60.120', 'na semana'),
      TvCard('Km produtivo', '60.039', '99,9% do programado', 'ok'),
      TvCard('Km ocioso', '2.410', '4,0% do total', 'warn'),
      TvCard('Frota em operação', '212', 'de 228 veículos', 'ok'),
      TvCard('Divergências', '2', 'a conferir', 'warn'),
    ],
    'Km produtivo por dia · últimas 6 semanas',
    'Km produtivo (mil)',
    [
      TvAlert('Linha 07', 'Veículo recolhido · 64 km', 'warn'),
      TvAlert('Conferência', '2 divergências de km pendentes', 'warn'),
      TvAlert('Linha 02', 'Desvio de itinerário 13h–15h', 'bad'),
      TvAlert('Frota', '16 veículos em manutenção', 'ok'),
    ],
    9,
    10,
  ),
  TvSlide(
    'Ocorrências',
    'Ocorrências em andamento',
    [
      TvCard('Abertas agora', '5', '2 graves', 'bad'),
      TvCard('Hoje', '8', '+3 vs ontem', 'warn'),
      TvCard('Viagens perdidas', '5', 'linhas 03 e 06', 'bad'),
      TvCard('Tempo médio', '42 min', 'para resolução'),
      TvCard('Resolvidas', '96%', 'na semana', 'ok'),
    ],
    'Ocorrências por dia · últimas 6 semanas',
    'Ocorrências',
    [
      TvAlert('Linha 07', 'Quebra de veículo · 13:58', 'bad'),
      TvAlert('Linha 03', 'Viagem atrasada em 26 min · 14:10', 'warn'),
      TvAlert('Linha 01', 'Desvio por obra · 11:30', 'warn'),
      TvAlert('Linha 08', 'Ar-condicionado inoperante', 'warn'),
    ],
    13,
    7,
  ),
];
