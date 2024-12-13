import 'package:app_prod_atacado/app/home/home_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class RcaFilter extends StatefulWidget {
  const RcaFilter({super.key});

  @override
  State<RcaFilter> createState() => _RcaFilterState();
}

class _RcaFilterState extends State<RcaFilter> {
  HomeStore store = Modular.get<HomeStore>();
  DateFormat formatter = DateFormat('dd/MM/yyyy');
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        const Text('RCA: '),
        Row(children: [
          Radio<String>(
            value: 'mais',
            groupValue: store.typeRca,
            onChanged: (value) {
              setState(() {
                store.typeRca = value!;
              });
            },
          ),
          const Text('Mais vendidos'),
          const SizedBox(width: 10.0),
          Radio<String>(
            value: 'menos',
            groupValue: store.typeRca,
            onChanged: (value) {
              setState(() {
                store.typeRca = value!;
              });
            },
          ),
          const Text('Menos vendidos'),
        ]),
        const SizedBox(height: 10.0),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          store.startDateRca == null
              ? ElevatedButton(
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    ).then((date) {
                      if (date != null) {
                        setState(() {
                          store.startDateRca = date;
                        });
                      }
                    });
                  },
                  child: const Text('Data Inicial'),
                )
              : Column(
                  children: [
                    const Text('Início'),
                    Row(children: [
                      Text(
                        formatter.format(store.startDateRca!),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            store.startDateRca = null;
                          });
                        },
                      )
                    ])
                  ],
                ),
          const SizedBox(width: 10.0),
          store.endDateRca == null
              ? ElevatedButton(
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    ).then((date) {
                      if (date != null) {
                        setState(() {
                          if (store.startDateRca == null) {
                            store.filterStatusMessage =
                                'Selecione a data inicial';
                          } else if (date.isBefore(store.startDateRca!)) {
                            store.filterStatusMessage =
                                'Data final deve ser maior que a inicial';
                          } else {
                            store.endDateRca = date;
                          }
                        });
                      }
                    });
                  },
                  child: const Text('Data Final'),
                )
              : Column(
                  children: [
                    const Text('Fim'),
                    Row(children: [
                      Text(
                        formatter.format(store.endDateRca!),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            store.endDateRca = null;
                          });
                        },
                      )
                    ])
                  ],
                ),
        ]),
      ],
    );
  }
}
