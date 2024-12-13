import 'dart:async';
import 'dart:convert';

import 'package:app_prod_atacado/app/home/widgets/client_filter.dart';
import 'package:app_prod_atacado/app/home/widgets/mark_selector.dart';
import 'package:app_prod_atacado/app/home/widgets/product_filter.dart';
import 'package:app_prod_atacado/app/home/widgets/rca_filter.dart';
import 'package:app_prod_atacado/app/home/widgets/section_selector.dart';
import 'package:app_prod_atacado/app/home/widgets/supplier_selector.dart';
import 'package:app_prod_atacado/app/shared/models/client.dart';
import 'package:app_prod_atacado/app/shared/models/filter_widget.dart';
import 'package:app_prod_atacado/app/shared/models/mark.dart';
import 'package:app_prod_atacado/app/shared/models/product.dart';
import 'package:app_prod_atacado/app/shared/models/section.dart';
import 'package:app_prod_atacado/app/shared/models/supplier.dart';
import 'package:app_prod_atacado/app/shared/models/user.dart';
import 'package:app_prod_atacado/app/shared/utils/custom_dio.dart';
import 'package:app_prod_atacado/app/shared/utils/filter_option.dart';
import 'package:app_prod_atacado/app/shared/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

part 'home_store.g.dart';

class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {
  User? user;

  @observable
  bool isLoading = false;

  @observable
  bool searchLoading = false;

  @observable
  bool filtersLoading = false;

  @observable
  String searchStatusMessage = 'Digite o nome ou código para Pesquisa';

  @observable
  String filterStatusMessage = '';

  @observable
  int qtdItens = 9;

  @observable
  int filial = 14;

  List<Section> sections = [];

  @observable
  Section? selectedSection;

  ObservableList<Supplier> suppliers = ObservableList<Supplier>();
  ObservableList<Mark> marks = ObservableList<Mark>();

  @observable
  Supplier? selectedSupplier;

  @observable
  Mark? selectedMark;

  List<Client> clients = [];

  @observable
  Client? selectedClient;

  String? typeClient;

  DateTime? startDateClient;

  DateTime? endDateClient;

  String? typeRca;

  DateTime? startDateRca;

  DateTime? endDateRca;

  @observable
  Timer? debounce;

  String? codRca;

  Set<FilterOption> filterOptions = {FilterOption.secao};

  //filters controllers
  bool showSection = true;
  bool showSupplier = false;
  bool showClient = false;
  bool showRca = false;
  bool showProduct = false;
  bool showMark = false;

  @observable
  ObservableList<FilterWidget> filterWidgets = ObservableList<FilterWidget>();

  List<Product> products = [];

  TextEditingController productController = TextEditingController();

  @action
  Future<void> getSections() async {
    isLoading = true;
    try {
      var response = await dio.get('/secoes.php');
      logger.d(response.data);
      var data = json.decode(response.data);
      var secoesData = data['secoes'];
      sections = secoesData.map<Section>((e) => Section.fromJson(e)).toList();
      sections.insert(0, Section(codigo: '9999', descricao: 'Todas as Seções'));
      selectedSection = sections.first;
      isLoading = false;
      logger.d('Sessões carregadas');
      logger.d(sections);
    } catch (e) {
      logger.e('Erro ao buscar sessões');
      logger.e(e);
      isLoading = false;
      Modular.to.pushReplacementNamed('/');
    }
  }

  @action
  Future<void> searchFieldChanged(String search, String type) async {
    if (search.isEmpty) {
      if (type == 'supplier') {
        suppliers.clear();
        searchStatusMessage = 'Digite o nome ou código do fornecedor';
      }
      if (type == 'mark') {
        marks.clear();
        searchStatusMessage = 'Digite o nome ou código da marca';
      }
      if (type == 'client') {
        clients.clear();
        searchStatusMessage = 'Digite o nome ou código do cliente';
      }
      return;
    }
    if (search.length < 3) {
      return;
    }
    if (debounce?.isActive ?? false) {
      debounce?.cancel();
    }
    debounce = Timer(const Duration(milliseconds: 800), () {
      searchTerm(search, type);
    });
  }

  @action
  Future<void> searchTerm(String search, String type) async {
    searchLoading = true;
    String url = type == 'supplier' ? '/fornecedores.php' : '/clientes.php';
    switch (type) {
      case 'supplier':
        url = '/fornecedores.php';
        break;
      case 'mark':
        url = '/marca.php';
        break;
      default:
        url = '/fornecedores.php';
        break;
    }
    Map<String, String> query = {'search': removerAcentos(search)};
    if (type == 'supplier') {
      suppliers.clear();
    }
    if (type == 'mark') {
      marks.clear();
    }
    if (type == 'client') {
      clients.clear();
      query['codrca'] = codRca!;
    }
    try {
      var response = await dio.get(url, queryParameters: query);
      logger.d(response.data);
      var data = json.decode(response.data);
      if (data['success']) {
        var searchData = data['result'];
        if (searchData.isEmpty) {
          type == 'client'
              ? searchStatusMessage = 'Nenhum cliente encontrado'
              : searchStatusMessage = 'Nenhum fornecedor encontrado';
          return;
        }
        searchStatusMessage = '';
        /* suppliers =
          fornecedoresData.map<Supplier>((e) => Supplier.fromJson(e)).toList(); */
        searchData.forEach((e) {
          if (type == 'client') {
            clients.add(Client.fromJson(e));
          }
          if (type == 'supplier') {
            suppliers.add(Supplier.fromJson(e));
          }
          if (type == 'mark') {
            marks.add(Mark.fromJson(e));
          }
        });
        searchLoading = false;
        logger.d('Dados da Pesquisa carregados');
      } else {
        searchStatusMessage = 'Nenhum fornecedor encontrado';
        searchLoading = false;
      }
    } catch (e) {
      logger.e('Erro ao buscar fornecedores');
      logger.e(e);
      searchLoading = false;
    }
  }

  @action
  void updateFilterWidgets() {
    filterWidgets.clear();
    for (var option in filterOptions) {
      switch (option) {
        case FilterOption.secao:
          filterWidgets.add(
              const FilterWidget(title: 'Seção', child: SectionSelector()));
          break;
        case FilterOption.marca:
          filterWidgets
              .add(FilterWidget(title: 'Marca', child: MarkSelector()));
          break;
        case FilterOption.produto:
          filterWidgets.add(
              const FilterWidget(title: 'Produto', child: ProductFilter()));
        case FilterOption.fornecedor:
          filterWidgets.add(const FilterWidget(
              title: 'Fornecedor', child: SupplierSelector()));
          break;
        case FilterOption.cliente:
          filterWidgets
              .add(const FilterWidget(title: 'Cliente', child: ClientFilter()));
          break;
        case FilterOption.rca:
          filterWidgets
              .add(const FilterWidget(title: 'RCA', child: RcaFilter()));
          break;
      }
    }
  }

  Future<void> getProducts() async {
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    filtersLoading = true;
    Map<String, String> query = {
      'qtd_itens': qtdItens.toString(),
      'filial': filial.toString(),
    };
    for (var option in filterOptions) {
      switch (option) {
        case FilterOption.produto:
          if (productController.text.isEmpty) {
            filterStatusMessage = 'Digite o nome ou código do Produto';
            filtersLoading = false;
            return;
          }
          query['produto'] =
              removerAcentos(productController.text.toUpperCase());
          break;
        case FilterOption.marca:
          if (selectedMark == null) {
            filterStatusMessage = 'Digite o nome ou código da marca';
            filtersLoading = false;
            return;
          }
          query['marca'] = selectedMark!.codMarca.toString();
          break;
        case FilterOption.secao:
          if (selectedSection == null) {
            filterStatusMessage = 'Selecione uma Seção';
            filtersLoading = false;
            return;
          }
          query['secao'] = selectedSection!.codigo;
          break;
        case FilterOption.fornecedor:
          if (selectedSupplier == null) {
            filterStatusMessage = 'Selecione um Fornecedor';
            filtersLoading = false;
            return;
          }
          query['fornecedor'] = selectedSupplier!.id.toString();
          break;
        case FilterOption.cliente:
          if (selectedClient == null) {
            filterStatusMessage = 'Selecione um Cliente';
            filtersLoading = false;
            return;
          }
          if (typeClient == null) {
            filterStatusMessage = 'Selecione o Tipo de pesquisa para o Cliente';
            filtersLoading = false;
            return;
          }
          if (startDateClient == null || endDateClient == null) {
            filterStatusMessage =
                'Selecione as data de pesquisa para o Cliente';
            filtersLoading = false;
            return;
          }
          query['cliente'] = selectedClient!.id.toString();
          query['tipo_cliente'] = typeClient!;
          query['data_inicio_cliente'] = formatter.format(startDateClient!);
          query['data_fim_cliente'] = formatter.format(endDateClient!);
          break;
        case FilterOption.rca:
          if (typeRca == null) {
            filterStatusMessage = 'Selecione o Tipo de pesquisa para o RCA';
            filtersLoading = false;
            return;
          }
          if (startDateRca == null || endDateRca == null) {
            filterStatusMessage = 'Selecione as data de pesquisa para o RCA';
            filtersLoading = false;
            return;
          }
          query['rca'] = codRca!;
          query['tipo_rca'] = typeRca!;
          query['data_inicio_rca'] = formatter.format(startDateRca!);
          query['data_fim_rca'] = formatter.format(endDateRca!);
          break;
        default:
          break;
      }
    }
    try {
      var response = await dio.get('/produtos.php', queryParameters: query);
      logger.d(json.decode(response.data));
      var data = json.decode(response.data);
      if (data['success']) {
        var produtosData = data['produtos'];
        if (produtosData.isEmpty) {
          filterStatusMessage = 'Nenhum produto encontrado';
          filtersLoading = false;
          return;
        }
        filterStatusMessage = '';
        products =
            produtosData.map<Product>((e) => Product.fromJson(e)).toList();
        filtersLoading = false;
        logger.d('Produtos carregados');
        Modular.to.pushNamed('/products', arguments: [products, user]);
      } else {
        filterStatusMessage = 'Nenhum produto encontrado';
        filtersLoading = false;
      }
    } catch (e, trace) {
      logger.e('Erro ao buscar produtos');
      filterStatusMessage = 'Erro ao buscar produtos';
      logger.e(e);
      logger.e(trace);
      filtersLoading = false;
    }
  }

  String removerAcentos(String texto) {
    return texto
        .replaceAll('á', 'a')
        .replaceAll('à', 'a')
        .replaceAll('ã', 'a')
        .replaceAll('â', 'a')
        .replaceAll('é', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ç', 'c')
        .replaceAll('Á', 'A')
        .replaceAll('À', 'A')
        .replaceAll('Ã', 'A')
        .replaceAll('Â', 'A')
        .replaceAll('É', 'E')
        .replaceAll('Ê', 'E')
        .replaceAll('Í', 'I')
        .replaceAll('Ó', 'O')
        .replaceAll('Ô', 'O')
        .replaceAll('Õ', 'O')
        .replaceAll('Ú', 'U')
        .replaceAll('Ç', 'C');
  }
}
