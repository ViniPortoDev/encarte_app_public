// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProductsStore on ProductsStoreBase, Store {
  late final _$showPriceAtom =
      Atom(name: 'ProductsStoreBase.showPrice', context: context);

  @override
  bool get showPrice {
    _$showPriceAtom.reportRead();
    return super.showPrice;
  }

  @override
  set showPrice(bool value) {
    _$showPriceAtom.reportWrite(value, super.showPrice, () {
      super.showPrice = value;
    });
  }

  late final _$generateLoadingAtom =
      Atom(name: 'ProductsStoreBase.generateLoading', context: context);

  @override
  bool get generateLoading {
    _$generateLoadingAtom.reportRead();
    return super.generateLoading;
  }

  @override
  set generateLoading(bool value) {
    _$generateLoadingAtom.reportWrite(value, super.generateLoading, () {
      super.generateLoading = value;
    });
  }

  late final _$productsAtom =
      Atom(name: 'ProductsStoreBase.products', context: context);

  @override
  List<Product> get products {
    _$productsAtom.reportRead();
    return super.products;
  }

  @override
  set products(List<Product> value) {
    _$productsAtom.reportWrite(value, super.products, () {
      super.products = value;
    });
  }

  late final _$selectedProductsAtom =
      Atom(name: 'ProductsStoreBase.selectedProducts', context: context);

  @override
  ObservableMap<int, bool> get selectedProducts {
    _$selectedProductsAtom.reportRead();
    return super.selectedProducts;
  }

  @override
  set selectedProducts(ObservableMap<int, bool> value) {
    _$selectedProductsAtom.reportWrite(value, super.selectedProducts, () {
      super.selectedProducts = value;
    });
  }

  late final _$generatePdfAsyncAction =
      AsyncAction('ProductsStoreBase.generatePdf', context: context);

  @override
  Future<void> generatePdf() {
    return _$generatePdfAsyncAction.run(() => super.generatePdf());
  }

  late final _$generateImagesAsyncAction =
      AsyncAction('ProductsStoreBase.generateImages', context: context);

  @override
  Future<List<Uint8List?>> generateImages() {
    return _$generateImagesAsyncAction.run(() => super.generateImages());
  }

  late final _$ProductsStoreBaseActionController =
      ActionController(name: 'ProductsStoreBase', context: context);

  @override
  void toggleProductSelection(Product product) {
    final _$actionInfo = _$ProductsStoreBaseActionController.startAction(
        name: 'ProductsStoreBase.toggleProductSelection');
    try {
      return super.toggleProductSelection(product);
    } finally {
      _$ProductsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
showPrice: ${showPrice},
generateLoading: ${generateLoading},
products: ${products},
selectedProducts: ${selectedProducts}
    ''';
  }
}
