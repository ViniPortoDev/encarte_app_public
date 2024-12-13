import 'package:app_prod_atacado/app/home/home_store.dart';
import 'package:app_prod_atacado/app/home/widgets/search_client_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class ClientFilter extends StatefulWidget {
  const ClientFilter({super.key});

  @override
  State<ClientFilter> createState() => _ClientFilterState();
}

class _ClientFilterState extends State<ClientFilter> {
  HomeStore store = Modular.get<HomeStore>();
  DateFormat formatter = DateFormat('dd/MM/yyyy');
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Column(
        children: [
          const Divider(),
          const Text("Cliente:"),
          const SizedBox(height: 10.0),
          store.selectedClient == null
              ? ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const SearchClientDialog();
                      },
                    );
                  },
                  child: const Text('Buscar Cliente'),
                )
              : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(store.selectedClient!.name),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        store.selectedClient = null;
                      });
                    },
                    child: const Text('Limpar'),
                  ),
                  const SizedBox(width: 10.0),
                  Row(children: [
                    Radio<String>(
                      value: 'mais',
                      groupValue: store.typeClient,
                      onChanged: (value) {
                        setState(() {
                          store.typeClient = value!;
                        });
                      },
                    ),
                    const Text('Mais Comprados'),
                    //const SizedBox(width: 5.0),
                    Radio<String>(
                      value: 'menos',
                      groupValue: store.typeClient,
                      onChanged: (value) {
                        setState(() {
                          store.typeClient = value!;
                        });
                      },
                    ),
                    const Text('Menos Comprados'),
                  ]),
                  const SizedBox(width: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      store.startDateClient == null
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
                                      store.startDateClient = date;
                                    });
                                  }
                                });
                              },
                              child: const Text('Data Inicial'),
                            )
                          : Column(
                            children: [
                              const Text('Início'),
                              Row(
                                children: [
                                  Text(
                                      formatter
                                          .format(store.startDateClient!),
                                      style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold)),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        store.startDateClient = null;
                                      });
                                    },
                                    icon: const Icon(Icons.clear,
                                        color: Colors.red),
                                  ),
                                ],
                              ),
                            ],
                          ),
                      const SizedBox(width: 10.0),
                      store.endDateClient == null ? ElevatedButton(
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          ).then((date) {
                            if (date != null) {
                              setState(() {
                                if (store.startDateClient == null) {
                                  store.filterStatusMessage =
                                      'Selecione a data inicial';
                                } else if (date
                                    .isBefore(store.startDateClient!)) {
                                  store.filterStatusMessage =
                                      'Data final deve ser maior que a data inicial';
                                } else {
                                  store.endDateClient = date;
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
                          Row(
                            children: [
                              Text(
                                  formatter.format(store.endDateClient!),
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    store.endDateClient = null;
                                  });
                                },
                                icon: const Icon(Icons.clear, color: Colors.red),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ])
        ],
      );
    });
  }
}
