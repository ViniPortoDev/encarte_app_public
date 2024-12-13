import 'package:app_prod_atacado/app/home/home_store.dart';
import 'package:app_prod_atacado/app/home/widgets/filial_filter.dart';
import 'package:app_prod_atacado/app/home/widgets/qtd_itens.dart';
import 'package:app_prod_atacado/app/shared/models/user.dart';
import 'package:app_prod_atacado/app/shared/utils/filter_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeStore store = Modular.get<HomeStore>();

  @override
  initState() {
    super.initState();
    store.getSections();
    store.user = widget.user;
    store.codRca = widget.user.id;
    store.updateFilterWidgets();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Filtros'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                icon: const Icon(Icons.exit_to_app, color: Colors.white),
                onPressed: () {
                  Modular.to.pushReplacementNamed('/');
                },
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Observer(builder: (_) {
              return store.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /* const Text("Filtros:",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5.0), */
                          const FilialFilter(),
                          const SizedBox(height: 5.0),
                          const QuantidadeItens(),
                          const SizedBox(height: 5.0),
                          Column(children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: store.showSection,
                                        onChanged: (value) {
                                          setState(() {
                                            store.showSection = value!;
                                            if (store.showSection) {
                                              store.filterOptions
                                                  .add(FilterOption.secao);
                                            } else {
                                              store.filterOptions
                                                  .remove(FilterOption.secao);
                                            }
                                            store.updateFilterWidgets();
                                          });
                                        },
                                      ),
                                      const Text('Seção'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: store.showMark,
                                        onChanged: (value) {
                                          setState(() {
                                            store.showMark = value!;
                                            if (store.showMark) {
                                              store.filterOptions
                                                  .add(FilterOption.marca);
                                            } else {
                                              store.filterOptions
                                                  .remove(FilterOption.marca);
                                              store.productController.clear();
                                            }
                                            store.updateFilterWidgets();
                                          });
                                        },
                                      ),
                                      const Text('Marca'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: store.showProduct,
                                        onChanged: (value) {
                                          setState(() {
                                            store.showProduct = value!;
                                            if (store.showProduct) {
                                              store.filterOptions
                                                  .add(FilterOption.produto);
                                            } else {
                                              store.filterOptions
                                                  .remove(FilterOption.produto);
                                              store.productController.clear();
                                            }
                                            store.updateFilterWidgets();
                                          });
                                        },
                                      ),
                                      const Text('Produto'),
                                    ],
                                  ),
                                ]),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: store.showSupplier,
                                        onChanged: (value) {
                                          setState(() {
                                            store.showSupplier = value!;
                                            if (store.showSupplier) {
                                              store.filterOptions
                                                  .add(FilterOption.fornecedor);
                                            } else {
                                              store.filterOptions.remove(
                                                  FilterOption.fornecedor);
                                            }
                                            store.updateFilterWidgets();
                                          });
                                        },
                                      ),
                                      const Text('Fornecedor'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: store.showClient,
                                        onChanged: (value) {
                                          setState(() {
                                            store.showClient = value!;
                                            if (store.showClient) {
                                              store.filterOptions
                                                  .add(FilterOption.cliente);
                                            } else {
                                              store.filterOptions
                                                  .remove(FilterOption.cliente);
                                            }
                                            store.updateFilterWidgets();
                                          });
                                        },
                                      ),
                                      const Text('Cliente'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: store.showRca,
                                        onChanged: (value) {
                                          setState(() {
                                            store.showRca = value!;
                                            if (store.showRca) {
                                              store.filterOptions
                                                  .add(FilterOption.rca);
                                            } else {
                                              store.filterOptions
                                                  .remove(FilterOption.rca);
                                            }
                                            store.updateFilterWidgets();
                                          });
                                        },
                                      ),
                                      const Text('RCA'),
                                    ],
                                  ),
                                ]),
                          ]),
                          const SizedBox(height: 10.0),
                          Observer(builder: (_) {
                            return width > 600
                                ? GridView.builder(
                                    shrinkWrap: true,
                                    itemCount: store.filterWidgets.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: width > 600 ? 2 : 1,
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0,
                                      childAspectRatio: 1.4,
                                    ),
                                    itemBuilder: (context, index) {
                                      return Container(
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: store.filterWidgets[index]);
                                    },
                                  )
                                : Column(
                                    children: store.filterWidgets,
                                  );
                          }),
                          const Divider(),
                          const SizedBox(height: 10.0),
                          ElevatedButton(
                            onPressed: () {
                              store.filtersLoading ? null : store.getProducts();
                            },
                            child: const Text('Buscar Produtos'),
                          ),
                          const SizedBox(height: 10.0),
                          Observer(builder: (_) {
                            return store.filtersLoading
                                ? const CircularProgressIndicator()
                                : Text(store.filterStatusMessage);
                          }),
                        ],
                      ),
                    );
            }),
          ),
        ));
  }
}
