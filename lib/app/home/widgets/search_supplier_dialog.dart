import 'package:app_prod_atacado/app/home/home_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SearchSupplierDialog extends StatefulWidget {
  const SearchSupplierDialog({super.key});

  @override
  State<SearchSupplierDialog> createState() => _SearchSupplierDialogState();
}

class _SearchSupplierDialogState extends State<SearchSupplierDialog> {
  HomeStore store = Modular.get<HomeStore>();

  @override
  void dispose() {
    store.searchLoading = false;
    store.debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return AlertDialog(
      title: const Text('Buscar Fornecedor'),
      content: SizedBox(
        width: width > 600 ? width * 0.8 : width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              decoration:  const InputDecoration(
                labelText: 'Nome ou Código do Fornecedor',
                border:  OutlineInputBorder(),
              ),
              onChanged: (value) async {
                store.searchFieldChanged(value, 'supplier');
              },
            ),
            const SizedBox(height: 10),
            Observer(
              builder: (_) {
                return store.searchLoading
                    ? const Center(child: CircularProgressIndicator())
                    : store.suppliers.isEmpty
                        ? Text(store.searchStatusMessage)
                        : Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount:store.suppliers.length,
                              itemBuilder: (context, index) {

                                var supplier = store.suppliers[index];
                                return ListTile(
                                  title: Text(supplier.name),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(supplier.fantasyName),
                                      Text('Codigo: ${supplier.id.toString()} - CNPJ: ${supplier.cnpj}'),
                                    ],
                                  ),
                                  onTap: () {
                                    store.selectedSupplier = supplier;
                                    store.suppliers.clear();
                                    Navigator.of(context)
                                        .pop(store.selectedSupplier);
                                  },
                                );
                              },
                            ),
                          );
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            store.suppliers.clear();
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
