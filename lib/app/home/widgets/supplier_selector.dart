import 'package:app_prod_atacado/app/home/home_store.dart';
import 'package:app_prod_atacado/app/home/widgets/search_supplier_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SupplierSelector extends StatefulWidget {
  const SupplierSelector({super.key});

  @override
  State<SupplierSelector> createState() => _SupplierSelectorState();
}

class _SupplierSelectorState extends State<SupplierSelector> {
  HomeStore store = Modular.get<HomeStore>();
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Column(
        children: [
          const Divider(),
          const Text("Fornecedor:"),
          const SizedBox(height: 10.0),
          store.selectedSupplier == null
              ? ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const SearchSupplierDialog();
                        });
                  },
                  child: const Text('Buscar Fornecedor'),
                )
              : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(store.selectedSupplier!.name),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        store.selectedSupplier = null;
                      });
                    },
                    child: const Text('Limpar'),
                  ),
                ]),
        ],
      );
    });
  }
}
