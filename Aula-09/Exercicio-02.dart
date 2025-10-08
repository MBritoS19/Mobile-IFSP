import 'package:flutter/material.dart';

const corAtivaCartao = Color(0xFF323244);
const corInativaCartao = Color(0xFF24263B);
const corBotaoPrincipal = Color(0xFF1de9b6);
const estiloLabel = TextStyle(fontSize: 18.0, color: Color(0xFF8D8E98));
const estiloNumero = TextStyle(fontSize: 50.0, fontWeight: FontWeight.w900);

enum TipoPet { gato, cachorro }

void main() => runApp(const CalculadoraIdadePet());

class CalculadoraIdadePet extends StatelessWidget {
  const CalculadoraIdadePet({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF1a1a2e),
        scaffoldBackgroundColor: const Color(0xFF1a1a2e),
      ),
      home: const PaginaPrincipal(),
    );
  }
}

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  TipoPet? petSelecionado;
  double peso = 15;
  int idadePet = 5;
  int? idadeHumana;

  void _calcularIdade() {
    if (petSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione um tipo de pet.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    int idadeCalculada = 0;
    if (petSelecionado == TipoPet.gato) {
      if (idadePet == 1) {
        idadeCalculada = 15;
      } else if (idadePet == 2) {
        idadeCalculada = 24;
      } else {
        idadeCalculada = 24 + (idadePet - 2) * 4;
      }
    } else {
      int fatorAno;
      if (peso < 10) {
        fatorAno = 4;
      } else if (peso <= 25) {
        fatorAno = 5;
      } else {
        fatorAno = 6;
      }

      if (idadePet == 1) {
        idadeCalculada = 15;
      } else if (idadePet == 2) {
        idadeCalculada = 24;
      } else {
        idadeCalculada = 24 + (idadePet - 2) * fatorAno;
      }
    }

    setState(() {
      idadeHumana = idadeCalculada;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CALCULADORA DE IDADE PET'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: CartaoPadrao(
                    aoPressionar: () =>
                        setState(() => petSelecionado = TipoPet.gato),
                    cor: petSelecionado == TipoPet.gato
                        ? corAtivaCartao
                        : corInativaCartao,
                    filhoCartao:
                        const ConteudoIcone(icone: Icons.pets, label: 'GATO'),
                  ),
                ),
                Expanded(
                  child: CartaoPadrao(
                    aoPressionar: () =>
                        setState(() => petSelecionado = TipoPet.cachorro),
                    cor: petSelecionado == TipoPet.cachorro
                        ? corAtivaCartao
                        : corInativaCartao,
                    filhoCartao: const ConteudoIcone(
                        icone: Icons.pets, label: 'CACHORRO'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: CartaoPadrao(
              cor: corAtivaCartao,
              filhoCartao: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('PESO', style: estiloLabel),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(peso.toStringAsFixed(1), style: estiloNumero),
                      const Text('kg', style: estiloLabel),
                    ],
                  ),
                  Slider(
                    value: peso,
                    min: 1.0,
                    max: 50.0,
                    activeColor: corBotaoPrincipal,
                    inactiveColor: const Color(0xFF8D8E98),
                    onChanged: (double novoValor) =>
                        setState(() => peso = novoValor),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: CartaoPadrao(
              cor: corAtivaCartao,
              filhoCartao: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('IDADE DO PET', style: estiloLabel),
                  Text(idadePet.toString(), style: estiloNumero),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      BotaoArredondado(
                        icone: Icons.remove,
                        aoPressionar: () => setState(() {
                          if (idadePet > 1) idadePet--;
                        }),
                      ),
                      const SizedBox(width: 10.0),
                      BotaoArredondado(
                        icone: Icons.add,
                        aoPressionar: () => setState(() => idadePet++),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          if (idadeHumana != null)
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Idade Humana: $idadeHumana anos',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: corBotaoPrincipal,
                ),
              ),
            ),
          BotaoInferior(
            textoBotao: 'CALCULAR',
            aoPressionar: _calcularIdade,
          ),
        ],
      ),
    );
  }
}

class BotaoInferior extends StatelessWidget {
  const BotaoInferior(
      {super.key, required this.textoBotao, required this.aoPressionar});

  final String textoBotao;
  final VoidCallback aoPressionar;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: aoPressionar,
      child: Container(
        color: corBotaoPrincipal,
        margin: const EdgeInsets.only(top: 10.0),
        width: double.infinity,
        height: 80.0,
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Center(
            child: Text(textoBotao,
                style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black))),
      ),
    );
  }
}

class BotaoArredondado extends StatelessWidget {
  const BotaoArredondado(
      {super.key, required this.icone, required this.aoPressionar});

  final IconData icone;
  final VoidCallback aoPressionar;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 6.0,
      constraints: const BoxConstraints.tightFor(width: 56.0, height: 56.0),
      shape: const CircleBorder(),
      fillColor: const Color(0xFF4C4F5E),
      onPressed: aoPressionar,
      child: Icon(icone),
    );
  }
}

class CartaoPadrao extends StatelessWidget {
  const CartaoPadrao(
      {super.key, required this.cor, this.filhoCartao, this.aoPressionar});

  final Color cor;
  final Widget? filhoCartao;
  final VoidCallback? aoPressionar;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: aoPressionar,
      child: Container(
        margin: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: cor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: filhoCartao,
      ),
    );
  }
}

class ConteudoIcone extends StatelessWidget {
  const ConteudoIcone({super.key, required this.icone, required this.label});

  final IconData icone;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icone, size: 80.0),
        const SizedBox(height: 15.0),
        Text(label, style: estiloLabel),
      ],
    );
  }
}
