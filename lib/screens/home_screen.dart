import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'package:calculadora_taxas/models/maquina.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MoneyMaskedTextController _controller =
      MoneyMaskedTextController(leftSymbol: 'R\$ ');

  final _maquina = Maquina(
    taxaDebito: 1.48,
    taxasCredito: [
      2.96,
      3.59,
      3.93,
      4.26,
      4.59,
      4.92,
      5.83,
      6.16,
      6.48,
      6.81,
      7.13,
      7.44,
    ],
  );
  final _currency = NumberFormat.simpleCurrency(locale: "pt_BR");

  String calculoJuros(double taxa) =>
      _currency.format(_maquina.valorTransacao / (1 - taxa / 100));

  String calculoParcela(double taxa, int parcela) =>
      _currency.format(_maquina.valorTransacao / (1 - taxa / 100) / parcela);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Calculadora Taxas",
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      'Valor Transação: ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 100,
                      child: TextField(
                        maxLength: 11,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        controller: _controller,
                        decoration: InputDecoration(counterText: ''),
                        onChanged: (valor) {
                          setState(() {
                            _maquina.valorTransacao = _controller.numberValue;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    DataTable(
                      columns: [
                        DataColumn(
                          label: Text(
                            'Pagamento',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Parcelas',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(
                            Text('Débito'),
                          ),
                          DataCell(
                            Text('${calculoParcela(_maquina.taxaDebito, 1)}'),
                          ),
                          DataCell(
                            Text('${calculoJuros(_maquina.taxaDebito)}'),
                          ),
                        ]),
                        ..._maquina.taxasCredito
                            .asMap()
                            .map((parcela, taxaCredito) => MapEntry(
                                  parcela,
                                  DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                          '${parcela + 1}x',
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                            '${calculoParcela(taxaCredito, parcela + 1)}'),
                                      ),
                                      DataCell(
                                        Text(
                                          '${calculoJuros(taxaCredito)}',
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .values
                            .toList()
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
