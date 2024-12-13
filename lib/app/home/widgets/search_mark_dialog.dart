import 'package:app_prod_atacado/app/home/home_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SearchMarkDialog extends StatefulWidget {
  const SearchMarkDialog({super.key});

  @override
  State<SearchMarkDialog> createState() => _SearchMarkDialogState();
}

class _SearchMarkDialogState extends State<SearchMarkDialog> {
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
      title: const Text('Buscar Marca'),
      content: SizedBox(
        width: width > 600 ? width * 0.8 : width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                labelText: 'Nome ou código da marca',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) async {
                store.searchFieldChanged(value, 'mark');
              },
            ),
            const SizedBox(height: 10),
            Observer(
              builder: (_) {
                return store.searchLoading
                    ? const Center(child: CircularProgressIndicator())
                    : store.marks.isEmpty
                        ? Text(store.searchStatusMessage)
                        : Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: store.marks.length,
                              itemBuilder: (context, index) {
                                var mark = store.marks[index];
                                return ListTile(
                                  title: Text(mark.marca),
                                  subtitle: Text(mark.codMarca),
                                  onTap: () {
                                    store.selectedMark = mark;
                                    store.marks.clear();
                                    Navigator.of(context)
                                        .pop(store.selectedMark);
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
            store.marks.clear();
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
