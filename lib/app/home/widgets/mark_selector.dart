import 'package:app_prod_atacado/app/home/home_store.dart';
import 'package:app_prod_atacado/app/home/widgets/search_mark_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MarkSelector extends StatefulWidget {
  MarkSelector({super.key});

  @override
  State<MarkSelector> createState() => _MarkSelectorState();
}

class _MarkSelectorState extends State<MarkSelector> {
  HomeStore store = Modular.get<HomeStore>();

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Column(
        children: [
          const Divider(),
          const Text("Marca:"),
          const SizedBox(height: 10.0),
          store.selectedMark == null
              ? ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const SearchMarkDialog();
                        });
                  },
                  child: const Text('Buscar Marca'),
                )
              : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(store.selectedMark!.marca),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        store.selectedMark = null;
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
