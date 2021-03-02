import 'package:flutter/foundation.dart';

class Maquina {
  String nome;
  double valorTransacao;
  final double taxaDebito;
  final List<double> taxasCredito;

  Maquina({
    this.nome = 'Stone Ton T2+ Mega',
    this.valorTransacao = 0,
    @required this.taxaDebito,
    @required this.taxasCredito,
  });
}
