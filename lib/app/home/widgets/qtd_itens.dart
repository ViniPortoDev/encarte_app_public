import 'package:app_prod_atacado/app/home/home_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class QuantidadeItens extends StatefulWidget {
  const QuantidadeItens({super.key});

  @override
  State<QuantidadeItens> createState() => _QuantidadeItensState();
}

class _QuantidadeItensState extends State<QuantidadeItens> {
  HomeStore store = Modular.get<HomeStore>();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    TextStyle style = TextStyle(fontSize: width < 400 ? 8 : 12);
    return  Column(
      children: [
        const Text('Quantidade de Itens'),
        SegmentedButton<int>(segments: [
          ButtonSegment<int>(
            value: 9,
            label: Text('9',
            style: style,
            ),
          ),
          ButtonSegment<int>(
            value: 18,
            label: Text('18',
            style: style,
            ),
          ),
          ButtonSegment<int>(
            value: 27,
            label: Text('27',
            style: style,),
          ),
          ButtonSegment<int>(
            value: 36,
            label: Text('36',
            style: style,),
          ),
          ButtonSegment<int>(
            value: 45,
            label: Text('45',
            style: style,),
          ),
        ],
        selected: {store.qtdItens},
        onSelectionChanged: (value) {
          setState(() {
            store.qtdItens = value.first;
          });
        },
        ),
      ],
    );
  }
}
