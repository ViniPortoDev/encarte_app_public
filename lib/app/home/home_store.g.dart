// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on HomeStoreBase, Store {
  late final _$isLoadingAtom =
      Atom(name: 'HomeStoreBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$searchLoadingAtom =
      Atom(name: 'HomeStoreBase.searchLoading', context: context);

  @override
  bool get searchLoading {
    _$searchLoadingAtom.reportRead();
    return super.searchLoading;
  }

  @override
  set searchLoading(bool value) {
    _$searchLoadingAtom.reportWrite(value, super.searchLoading, () {
      super.searchLoading = value;
    });
  }

  late final _$filtersLoadingAtom =
      Atom(name: 'HomeStoreBase.filtersLoading', context: context);

  @override
  bool get filtersLoading {
    _$filtersLoadingAtom.reportRead();
    return super.filtersLoading;
  }

  @override
  set filtersLoading(bool value) {
    _$filtersLoadingAtom.reportWrite(value, super.filtersLoading, () {
      super.filtersLoading = value;
    });
  }

  late final _$searchStatusMessageAtom =
      Atom(name: 'HomeStoreBase.searchStatusMessage', context: context);

  @override
  String get searchStatusMessage {
    _$searchStatusMessageAtom.reportRead();
    return super.searchStatusMessage;
  }

  @override
  set searchStatusMessage(String value) {
    _$searchStatusMessageAtom.reportWrite(value, super.searchStatusMessage, () {
      super.searchStatusMessage = value;
    });
  }

  late final _$filterStatusMessageAtom =
      Atom(name: 'HomeStoreBase.filterStatusMessage', context: context);

  @override
  String get filterStatusMessage {
    _$filterStatusMessageAtom.reportRead();
    return super.filterStatusMessage;
  }

  @override
  set filterStatusMessage(String value) {
    _$filterStatusMessageAtom.reportWrite(value, super.filterStatusMessage, () {
      super.filterStatusMessage = value;
    });
  }

  late final _$qtdItensAtom =
      Atom(name: 'HomeStoreBase.qtdItens', context: context);

  @override
  int get qtdItens {
    _$qtdItensAtom.reportRead();
    return super.qtdItens;
  }

  @override
  set qtdItens(int value) {
    _$qtdItensAtom.reportWrite(value, super.qtdItens, () {
      super.qtdItens = value;
    });
  }

  late final _$filialAtom =
      Atom(name: 'HomeStoreBase.filial', context: context);

  @override
  int get filial {
    _$filialAtom.reportRead();
    return super.filial;
  }

  @override
  set filial(int value) {
    _$filialAtom.reportWrite(value, super.filial, () {
      super.filial = value;
    });
  }

  late final _$selectedSectionAtom =
      Atom(name: 'HomeStoreBase.selectedSection', context: context);

  @override
  Section? get selectedSection {
    _$selectedSectionAtom.reportRead();
    return super.selectedSection;
  }

  @override
  set selectedSection(Section? value) {
    _$selectedSectionAtom.reportWrite(value, super.selectedSection, () {
      super.selectedSection = value;
    });
  }

  late final _$selectedSupplierAtom =
      Atom(name: 'HomeStoreBase.selectedSupplier', context: context);

  @override
  Supplier? get selectedSupplier {
    _$selectedSupplierAtom.reportRead();
    return super.selectedSupplier;
  }

  @override
  set selectedSupplier(Supplier? value) {
    _$selectedSupplierAtom.reportWrite(value, super.selectedSupplier, () {
      super.selectedSupplier = value;
    });
  }

  late final _$selectedMarkAtom =
      Atom(name: 'HomeStoreBase.selectedMark', context: context);

  @override
  Mark? get selectedMark {
    _$selectedMarkAtom.reportRead();
    return super.selectedMark;
  }

  @override
  set selectedMark(Mark? value) {
    _$selectedMarkAtom.reportWrite(value, super.selectedMark, () {
      super.selectedMark = value;
    });
  }

  late final _$selectedClientAtom =
      Atom(name: 'HomeStoreBase.selectedClient', context: context);

  @override
  Client? get selectedClient {
    _$selectedClientAtom.reportRead();
    return super.selectedClient;
  }

  @override
  set selectedClient(Client? value) {
    _$selectedClientAtom.reportWrite(value, super.selectedClient, () {
      super.selectedClient = value;
    });
  }

  late final _$debounceAtom =
      Atom(name: 'HomeStoreBase.debounce', context: context);

  @override
  Timer? get debounce {
    _$debounceAtom.reportRead();
    return super.debounce;
  }

  @override
  set debounce(Timer? value) {
    _$debounceAtom.reportWrite(value, super.debounce, () {
      super.debounce = value;
    });
  }

  late final _$filterWidgetsAtom =
      Atom(name: 'HomeStoreBase.filterWidgets', context: context);

  @override
  ObservableList<FilterWidget> get filterWidgets {
    _$filterWidgetsAtom.reportRead();
    return super.filterWidgets;
  }

  @override
  set filterWidgets(ObservableList<FilterWidget> value) {
    _$filterWidgetsAtom.reportWrite(value, super.filterWidgets, () {
      super.filterWidgets = value;
    });
  }

  late final _$getSectionsAsyncAction =
      AsyncAction('HomeStoreBase.getSections', context: context);

  @override
  Future<void> getSections() {
    return _$getSectionsAsyncAction.run(() => super.getSections());
  }

  late final _$searchFieldChangedAsyncAction =
      AsyncAction('HomeStoreBase.searchFieldChanged', context: context);

  @override
  Future<void> searchFieldChanged(String search, String type) {
    return _$searchFieldChangedAsyncAction
        .run(() => super.searchFieldChanged(search, type));
  }

  late final _$searchTermAsyncAction =
      AsyncAction('HomeStoreBase.searchTerm', context: context);

  @override
  Future<void> searchTerm(String search, String type) {
    return _$searchTermAsyncAction.run(() => super.searchTerm(search, type));
  }

  late final _$HomeStoreBaseActionController =
      ActionController(name: 'HomeStoreBase', context: context);

  @override
  void updateFilterWidgets() {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.updateFilterWidgets');
    try {
      return super.updateFilterWidgets();
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
searchLoading: ${searchLoading},
filtersLoading: ${filtersLoading},
searchStatusMessage: ${searchStatusMessage},
filterStatusMessage: ${filterStatusMessage},
qtdItens: ${qtdItens},
filial: ${filial},
selectedSection: ${selectedSection},
selectedSupplier: ${selectedSupplier},
selectedMark: ${selectedMark},
selectedClient: ${selectedClient},
debounce: ${debounce},
filterWidgets: ${filterWidgets}
    ''';
  }
}
