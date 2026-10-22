import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

// ============================================================================
// DADOS DO PERFIL: edite aqui com suas informações
// ============================================================================
class Perfil {
  static const nome = 'João Vitor Morais Dias';
  static const iniciais = 'JV';
  static const cargo = 'Analista de Dados';
  static const email = 'joao.dias20@aluno.cps.sp.gov.br';
  static const linkedin = 'https://www.linkedin.com/in/joao-vitor-moraisd/R';
  static const github = 'https://github.com/MoraiisDev';
  static const repositorioProjeto = 'https://github.com/MoraiisDev';
  static const deployProjeto = 'https://github.com/MoraiisDev';
}

class Cores {
  static const bg = Color(0xFFF4F6F7);
  static const ink = Color(0xFF10252D);
  static const teal = Color(0xFF1C6E78);
  static const amber = Color(0xFFF2B01E);
  static const mist = Color(0xFFD9E3E6);
  static const muted = Color(0xFF55696F);
  static const white = Color(0xFFFFFFFF);
}

TextStyle titulo(double tamanho, {Color cor = Cores.ink}) =>
    GoogleFonts.bricolageGrotesque(
      fontSize: tamanho,
      fontWeight: FontWeight.w700,
      color: cor,
      height: 1.1,
      letterSpacing: -0.5,
    );

TextStyle corpo({
  double tamanho = 16,
  Color cor = Cores.muted,
  FontWeight peso = FontWeight.w400,
}) =>
    GoogleFonts.ibmPlexSans(
      fontSize: tamanho,
      color: cor,
      fontWeight: peso,
      height: 1.55,
    );

Future<void> abrir(String url) async {
  await launchUrl(Uri.parse(url), webOnlyWindowName: '_blank');
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '${Perfil.nome} | Portfólio de Dados',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Cores.bg,
        colorScheme: ColorScheme.fromSeed(seedColor: Cores.teal),
      ),
      home: const MyHomePage(title: 'Portfólio de Dados'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _kProjetos = GlobalKey();
  final _kSobre = GlobalKey();
  final _kContato = GlobalKey();

  void _ir(GlobalKey k) {
    final ctx = k.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 760;
    final espaco = mobile ? 44.0 : 64.0;

    return Scaffold(
      body: Column(
        children: [
          _Cabecalho(
            mobile: mobile,
            onProjetos: () => _ir(_kProjetos),
            onSobre: () => _ir(_kSobre),
            onContato: () => _ir(_kContato),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1080),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: mobile ? 20 : 32, vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          key: _kProjetos,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _Destaque(mobile: mobile),
                            SizedBox(height: espaco),
                            _PreviaPainel(mobile: mobile),
                            SizedBox(height: espaco),
                            _ProblemaSolucao(mobile: mobile),
                            SizedBox(height: espaco),
                            const _Tecnologias(),
                            SizedBox(height: espaco),
                            _Features(mobile: mobile),
                            SizedBox(height: espaco),
                            const _Resultados(),
                            SizedBox(height: espaco),
                            _OutrosProjetos(mobile: mobile),
                          ],
                        ),
                        SizedBox(height: espaco),
                        Container(key: _kSobre, child: _Sobre(mobile: mobile)),
                        SizedBox(height: espaco),
                        Container(
                            key: _kContato, child: _Contato(mobile: mobile)),
                        const SizedBox(height: 32),
                        Text(
                          'Projetos e números deste portfólio são fictícios e '
                          'têm fins acadêmicos.',
                          style: corpo(tamanho: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// Cabeçalho
// ----------------------------------------------------------------------------
class _Cabecalho extends StatelessWidget {
  const _Cabecalho({
    required this.mobile,
    required this.onProjetos,
    required this.onSobre,
    required this.onContato,
  });
  final bool mobile;
  final VoidCallback onProjetos, onSobre, onContato;

  @override
  Widget build(BuildContext context) {
    Widget link(String t, VoidCallback f) => TextButton(
          onPressed: f,
          child: Text(t,
              style: corpo(
                  tamanho: 15, cor: Cores.ink, peso: FontWeight.w500)),
        );

    return Container(
      decoration: const BoxDecoration(
        color: Cores.bg,
        border: Border(bottom: BorderSide(color: Cores.mist)),
      ),
      padding: EdgeInsets.symmetric(horizontal: mobile ? 20 : 32, vertical: 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Cores.ink,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(Perfil.iniciais,
                    style: titulo(14, cor: Cores.amber)),
              ),
              const SizedBox(width: 12),
              Text(Perfil.nome, style: titulo(18)),
              const Spacer(),
              if (mobile)
                PopupMenuButton<int>(
                  icon: const Icon(Icons.menu, color: Cores.ink),
                  onSelected: (i) => [onProjetos, onSobre, onContato][i](),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 0, child: Text('Projetos')),
                    PopupMenuItem(value: 1, child: Text('Sobre')),
                    PopupMenuItem(value: 2, child: Text('Contato')),
                  ],
                )
              else ...[
                link('Projetos', onProjetos),
                link('Sobre', onSobre),
                link('Contato', onContato),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// Blocos reutilizáveis
// ----------------------------------------------------------------------------
class _Cartao extends StatelessWidget {
  const _Cartao({
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.cor = Cores.white,
    this.raio = 14,
  });
  final Widget child;
  final EdgeInsets padding;
  final Color cor;
  final double raio;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: cor,
          borderRadius: BorderRadius.circular(raio),
          border: Border.all(color: Cores.mist),
        ),
        child: child,
      );
}

class _Tag extends StatelessWidget {
  const _Tag(this.texto);
  final String texto;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Cores.mist,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(texto,
            style: corpo(tamanho: 13, cor: Cores.teal, peso: FontWeight.w600)),
      );
}

class _TituloSecao extends StatelessWidget {
  const _TituloSecao(this.texto, {this.sub});
  final String texto;
  final String? sub;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(texto, style: titulo(28)),
            if (sub != null) ...[
              const SizedBox(height: 6),
              Text(sub!, style: corpo()),
            ],
          ],
        ),
      );
}

// ----------------------------------------------------------------------------
// 1. Card de destaque
// ----------------------------------------------------------------------------
class _Destaque extends StatelessWidget {
  const _Destaque({required this.mobile});
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    return _Cartao(
      raio: 20,
      padding: EdgeInsets.all(mobile ? 22 : 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Tag('Power BI'),
              _Tag('SQL'),
              _Tag('Google Cloud'),
              _Tag('Mar 2026'),
            ],
          ),
          const SizedBox(height: 22),
          Text('Painel de Universidade Corporativa',
              style: titulo(mobile ? 32 : 52)),
          const SizedBox(height: 14),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Text(
              'Um painel que mostra, em um só lugar, quem está treinando, '
              'quanto conclui e onde a empresa precisa investir em '
              'capacitação, com dados atualizados todos os dias.',
              style: corpo(tamanho: 18),
            ),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              OutlinedButton.icon(
                onPressed: () => abrir(Perfil.repositorioProjeto),
                icon: const Icon(Icons.code, size: 18),
                label: const Text('Ver código no GitHub'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Cores.ink,
                  side: const BorderSide(color: Cores.ink),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 16),
                ),
              ),
              FilledButton.icon(
                onPressed: () => abrir(Perfil.deployProjeto),
                icon: const Icon(Icons.open_in_new, size: 18),
                label: const Text('Acessar o painel'),
                style: FilledButton.styleFrom(
                  backgroundColor: Cores.amber,
                  foregroundColor: Cores.ink,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// 2. Prévia visual do painel (desenhada com widgets, sem imagens externas)
// ----------------------------------------------------------------------------
class _PreviaPainel extends StatelessWidget {
  const _PreviaPainel({required this.mobile});
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    const painel = Color(0x14FFFFFF);

    Widget kpi(String rotulo, String valor, double largura) => SizedBox(
          width: largura,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: painel,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rotulo,
                    style: corpo(tamanho: 13, cor: Cores.mist)),
                const SizedBox(height: 4),
                Text(valor, style: titulo(26, cor: Cores.white)),
              ],
            ),
          ),
        );

    final graficoBarras = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: painel,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Conclusão de trilhas por área',
              style: corpo(
                  tamanho: 14, cor: Cores.white, peso: FontWeight.w600)),
          const SizedBox(height: 16),
          const _Barras(
            rotulos: ['Vendas', 'TI', 'RH', 'Ops', 'Fin'],
            valores: [0.82, 0.91, 0.74, 0.68, 0.88],
          ),
        ],
      ),
    );

    final graficoLinha = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: painel,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Adesão mensal aos treinamentos',
              style: corpo(
                  tamanho: 14, cor: Cores.white, peso: FontWeight.w600)),
          const SizedBox(height: 16),
          const _Linha(valores: [0.35, 0.42, 0.48, 0.55, 0.52, 0.63, 0.71, 0.78]),
        ],
      ),
    );

    return Container(
      padding: EdgeInsets.all(mobile ? 16 : 28),
      decoration: BoxDecoration(
        color: Cores.ink,
        borderRadius: BorderRadius.circular(20),
      ),
      child: LayoutBuilder(builder: (context, c) {
        final colunas = mobile ? 2 : 4;
        final w = (c.maxWidth - 12 * (colunas - 1)) / colunas;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Visão geral da Universidade Corporativa',
                style: titulo(20, cor: Cores.white)),
            const SizedBox(height: 4),
            Text('Cultura de aprendizado guiada por dados.',
                style: corpo(tamanho: 13, cor: Cores.mist)),
            const SizedBox(height: 18),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                kpi('Colaboradores ativos', '4.812', w),
                kpi('Taxa de conclusão', '78%', w),
                kpi('Horas por pessoa', '12,4 h', w),
                kpi('NPS (0 a 10)', '8,6', w),
              ],
            ),
            const SizedBox(height: 12),
            if (mobile) ...[
              graficoBarras,
              const SizedBox(height: 12),
              graficoLinha,
            ] else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: graficoBarras),
                  const SizedBox(width: 12),
                  Expanded(child: graficoLinha),
                ],
              ),
          ],
        );
      }),
    );
  }
}

class _Barras extends StatelessWidget {
  const _Barras({required this.rotulos, required this.valores});
  final List<String> rotulos;
  final List<double> valores;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutCubic,
      builder: (context, t, _) {
        return Column(
          children: [
            SizedBox(
              height: 130,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (var i = 0; i < valores.length; i++)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('${(valores[i] * 100).round()}%',
                                style: corpo(
                                    tamanho: 12, cor: Cores.mist)),
                            const SizedBox(height: 4),
                            Container(
                              height: 96 * valores[i] * t,
                              decoration: BoxDecoration(
                                color: i == 1 ? Cores.amber : Cores.teal,
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                for (final r in rotulos)
                  Expanded(
                    child: Text(r,
                        textAlign: TextAlign.center,
                        style: corpo(tamanho: 12, cor: Cores.mist)),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _Linha extends StatelessWidget {
  const _Linha({required this.valores});
  final List<double> valores;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1600),
      curve: Curves.easeOut,
      builder: (context, t, _) => SizedBox(
        height: 148,
        width: double.infinity,
        child: CustomPaint(painter: _LinhaPainter(valores, t)),
      ),
    );
  }
}

class _LinhaPainter extends CustomPainter {
  _LinhaPainter(this.valores, this.progresso);
  final List<double> valores;
  final double progresso;

  @override
  void paint(Canvas canvas, Size size) {
    final grade = Paint()
      ..color = const Color(0x22FFFFFF)
      ..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grade);
    }

    final caminho = Path();
    for (var i = 0; i < valores.length; i++) {
      final x = size.width * i / (valores.length - 1);
      final y = size.height * (1 - valores[i]);
      if (i == 0) {
        caminho.moveTo(x, y);
      } else {
        caminho.lineTo(x, y);
      }
    }
    final metrica = caminho.computeMetrics().first;
    final parcial = metrica.extractPath(0, metrica.length * progresso);
    canvas.drawPath(
      parcial,
      Paint()
        ..color = Cores.amber
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _LinhaPainter old) =>
      old.progresso != progresso;
}

// ----------------------------------------------------------------------------
// 3. Problema e solução
// ----------------------------------------------------------------------------
class _ProblemaSolucao extends StatelessWidget {
  const _ProblemaSolucao({required this.mobile});
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    Widget bloco(IconData icone, String titulo_, String texto) => _Cartao(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icone, color: Cores.teal, size: 28),
              const SizedBox(height: 12),
              Text(titulo_, style: titulo(20)),
              const SizedBox(height: 8),
              Text(texto, style: corpo()),
            ],
          ),
        );

    final desafio = bloco(
      Icons.report_problem_outlined,
      'O desafio',
      'O time de Treinamentos acompanhava os progressos dos cursos em '
          'planilhas espalhadas entre áreas. Fechar o relatório mensal levava '
          'dias e os números mudavam de uma versão para outra.',
    );
    final solucao = bloco(
      Icons.lightbulb_outline,
      'A solução',
      'Um pipeline que reúne as bases em um único modelo no BigQuery, '
          'trata os dados com Python e SQL e alimenta um painel no Power BI '
          'com uma definição única para cada indicador.',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _TituloSecao('O problema e a solução'),
        if (mobile) ...[
          desafio,
          const SizedBox(height: 16),
          solucao,
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: desafio),
              const SizedBox(width: 16),
              Expanded(child: solucao),
            ],
          ),
      ],
    );
  }
}

// ----------------------------------------------------------------------------
// 4. Arquitetura e tecnologias
// ----------------------------------------------------------------------------
class _Tecnologias extends StatelessWidget {
  const _Tecnologias();

  static const _itens = [
    ('SQL', 'Cria o modelo dimensional (tabelas fato e dimensão) e as '
        'consultas que sustentam cada indicador.', Color(0xFF1C6E78)),
    ('Py', 'Limpa, valida e carrega os arquivos de origem com pandas, '
        'antes de entrarem no banco.', Color(0xFF3D6FB6)),
    ('BQ', 'BigQuery guarda os dados e responde consultas grandes sem '
        'exigir servidor para administrar.', Color(0xFF4285F4)),
    ('CS', 'Cloud Storage recebe os arquivos brutos e Cloud Scheduler '
        'dispara a carga todas as manhãs.', Color(0xFF2E8B6E)),
    ('PBI', 'Power BI entrega o painel, com medidas em DAX e acesso por '
        'área (RLS).', Color(0xFFD99A00)),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _TituloSecao('Arquitetura e tecnologias',
            sub: 'Do arquivo de origem até o painel que o gestor abre.'),
        _Cartao(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            children: [
              for (var i = 0; i < _itens.length; i++) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _itens[i].$3,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(_itens[i].$1,
                            style: titulo(14, cor: Cores.white)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(_itens[i].$2, style: corpo()),
                        ),
                      ),
                    ],
                  ),
                ),
                if (i < _itens.length - 1)
                  const Divider(height: 1, color: Cores.mist),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// ----------------------------------------------------------------------------
// 5. Características principais
// ----------------------------------------------------------------------------
class _Features extends StatelessWidget {
  const _Features({required this.mobile});
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    const itens = [
      (Icons.insights_outlined, 'Painel executivo',
          'Indicadores de adesão, conclusão e horas, com detalhamento por '
              'área, trilha e curso.'),
      (Icons.update, 'Atualização diária',
          'A carga roda sozinha toda manhã. Ninguém precisa montar '
              'planilha para ver o número do dia.'),
      (Icons.lock_outline, 'Acesso por área',
          'Cada gestor vê só a sua equipe, usando segurança em nível de '
              'linha no Power BI.'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _TituloSecao('Características principais'),
        LayoutBuilder(builder: (context, c) {
          final colunas = mobile ? 1 : 3;
          final w = (c.maxWidth - 16 * (colunas - 1)) / colunas;
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final f in itens)
                SizedBox(
                  width: w,
                  child: _Cartao(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(f.$1, color: Cores.teal, size: 28),
                        const SizedBox(height: 12),
                        Text(f.$2, style: titulo(19)),
                        const SizedBox(height: 8),
                        Text(f.$3, style: corpo(tamanho: 15)),
                      ],
                    ),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }
}

// ----------------------------------------------------------------------------
// 6. Resultados e lições
// ----------------------------------------------------------------------------
class _Resultados extends StatelessWidget {
  const _Resultados();

  @override
  Widget build(BuildContext context) {
    Widget item(IconData icone, String rotulo, String texto) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icone, color: Cores.teal, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: corpo(cor: Cores.ink),
                    children: [
                      TextSpan(
                          text: '$rotulo: ',
                          style: corpo(
                              cor: Cores.ink, peso: FontWeight.w700)),
                      TextSpan(
                          text: texto,
                          style: corpo(cor: Cores.muted)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _TituloSecao('Resultados e lições aprendidas'),
        _Cartao(
          child: Column(
            children: [
              item(Icons.speed, 'Tempo',
                  'o fechamento mensal caiu de 3 dias para menos de 15 '
                      'minutos.'),
              item(Icons.groups_outlined, 'Adoção',
                  'a cobertura de treinamentos registrados subiu de 61% '
                      'para 94% dos colaboradores.'),
              item(Icons.school_outlined, 'Aprendizado',
                  'modelagem dimensional, medidas em DAX e a importância '
                      'de combinar com a área de negócio o que cada '
                      'indicador significa.'),
            ],
          ),
        ),
      ],
    );
  }
}

// ----------------------------------------------------------------------------
// 7. Outros projetos (fictícios)
// ----------------------------------------------------------------------------
class _OutrosProjetos extends StatelessWidget {
  const _OutrosProjetos({required this.mobile});
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    const itens = [
      ('Previsão de demanda semanal',
          'Modelo em Python que projeta pedidos das próximas semanas '
              'a partir de dados históricos no BigQuery.',
          ['Python', 'BigQuery']),
      ('Análise de cancelamento de clientes',
          'Consultas em SQL e visão no Power BI para identificar os '
              'perfis com maior risco de cancelar.',
          ['SQL', 'Power BI']),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _TituloSecao('Outros estudos'),
        LayoutBuilder(builder: (context, c) {
          final colunas = mobile ? 1 : 2;
          final w = (c.maxWidth - 16 * (colunas - 1)) / colunas;
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final p in itens)
                SizedBox(
                  width: w,
                  child: _Cartao(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.$1, style: titulo(20)),
                        const SizedBox(height: 8),
                        Text(p.$2, style: corpo(tamanho: 15)),
                        const SizedBox(height: 14),
                        Wrap(spacing: 8, runSpacing: 8, children: [
                          for (final t in p.$3) _Tag(t),
                        ]),
                      ],
                    ),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }
}

// ----------------------------------------------------------------------------
// Sobre
// ----------------------------------------------------------------------------
class _Sobre extends StatelessWidget {
  const _Sobre({required this.mobile});
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    const grupos = [
      ('Consulta e programação', ['SQL', 'Python', 'pandas', 'Modelagem dimensional']),
      ('Nuvem', ['Google Cloud (GCP)', 'BigQuery', 'Cloud Storage', 'Cloud Scheduler']),
      ('Visualização', ['Power BI', 'DAX', 'Power Query', 'Segurança em nível de linha']),
    ];

    final texto = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sobre', style: titulo(28)),
        const SizedBox(height: 14),
        Text(
          'Sou ${Perfil.cargo} e gosto de transformar dados espalhados em '
          'números que ajudam a decidir. Trabalho com SQL e Python para '
          'preparar as bases, com GCP para guardá-las e com Power BI para '
          'contar o que elas mostram.',
          style: corpo(tamanho: 17),
        ),
      ],
    );

    final habilidades = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final g in grupos) ...[
          Text(g.$1, style: corpo(cor: Cores.ink, peso: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final s in g.$2) _Tag(s),
          ]),
          const SizedBox(height: 18),
        ],
      ],
    );

    if (mobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [texto, const SizedBox(height: 24), habilidades],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: texto),
        const SizedBox(width: 48),
        Expanded(child: habilidades),
      ],
    );
  }
}

// ----------------------------------------------------------------------------
// 8. Chamada para ação
// ----------------------------------------------------------------------------
class _Contato extends StatelessWidget {
  const _Contato({required this.mobile});
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(mobile ? 24 : 40),
      decoration: BoxDecoration(
        color: Cores.ink,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Vamos trabalhar juntos?',
              style: titulo(mobile ? 28 : 36, cor: Cores.white)),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              'Gostou do projeto? Estou disponível para novos desafios em '
              'análise de dados.',
              style: corpo(tamanho: 17, cor: Cores.mist),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.icon(
                onPressed: () => abrir('mailto:${Perfil.email}'),
                icon: const Icon(Icons.mail_outline, size: 18),
                label: const Text('Enviar mensagem por e-mail'),
                style: FilledButton.styleFrom(
                  backgroundColor: Cores.amber,
                  foregroundColor: Cores.ink,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 16),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => abrir(Perfil.linkedin),
                icon: const Icon(Icons.person_outline, size: 18),
                label: const Text('Conectar no LinkedIn'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Cores.white,
                  side: const BorderSide(color: Cores.mist),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
