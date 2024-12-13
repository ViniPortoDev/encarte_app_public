import 'package:app_prod_atacado/app/home/home_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SectionSelector extends StatefulWidget {
  const SectionSelector({super.key});

  @override
  State<SectionSelector> createState() => _SectionSelectorState();
}

class _SectionSelectorState extends State<SectionSelector> {
  HomeStore store = Modular.get<HomeStore>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        const Text("Seção:"),
        const SizedBox(height: 10.0),
        DropdownButton<String>(
          value: store.selectedSection?.codigo,
          hint: const Text('Selecione uma Seção'),
          onChanged: (value) {
            setState(() {
              store.selectedSection = store.sections
                  .firstWhere((element) => element.codigo == value);
            });
          },
          items: store.sections
              .map((e) => DropdownMenuItem(
                    value: e.codigo,
                    child: Text(e.descricao),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
