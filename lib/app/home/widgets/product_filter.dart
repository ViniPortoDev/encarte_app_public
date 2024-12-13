import 'package:app_prod_atacado/app/home/home_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProductFilter extends StatelessWidget {
  const ProductFilter({super.key});
  @override
  Widget build(BuildContext context) {
    HomeStore store = Modular.get<HomeStore>();
    return Column(
      children: [
        const Divider(),
        const Text("Descrição Produto:"),
        const SizedBox(height: 10.0),
        TextField(
          controller: store.productController,
          decoration: const InputDecoration(
            labelText: 'Produto',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
