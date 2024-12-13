import 'package:app_prod_atacado/app/home/home_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SearchClientDialog extends StatefulWidget {
  const SearchClientDialog({super.key});

  @override
  State<SearchClientDialog> createState() => _SearchClientDialogState();
}

class _SearchClientDialogState extends State<SearchClientDialog> {
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
      title: const Text('Buscar Cliente'),
      content: SizedBox(
        width: width > 600 ? width * 0.8 : width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              decoration:  const InputDecoration(
                labelText: 'Nome ou Código do Cliente',
                border:  OutlineInputBorder(),
              ),
              onChanged: (value) async {
                store.searchFieldChanged(value, 'client');
              },
            ),
            const SizedBox(height: 10),
            Observer(
              builder: (_) {
                return store.searchLoading
                    ? const Center(child: CircularProgressIndicator())
                    : store.clients.isEmpty 
                        ? Text(store.searchStatusMessage)
                        : Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount:store.clients.length,
                              itemBuilder: (context, index) {

                                var client = store.clients[index];
                                return ListTile(
                                  title: Text(client.name),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(client.fantasyName),
                                      Text('CodCli: ${client.id.toString()}  - CNPJ: ${client.cnpj}'),
                                    ],
                                  ),
                                  onTap: () {
                                    store.selectedClient = client;
                                    store.clients.clear();
                                    Navigator.of(context)
                                        .pop(store.selectedClient);
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
            store.clients.clear();
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
