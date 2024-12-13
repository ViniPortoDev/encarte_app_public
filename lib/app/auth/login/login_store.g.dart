// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoginStore on LoginStoreBase, Store {
  late final _$isLoadingAtom =
      Atom(name: 'LoginStoreBase.isLoading', context: context);

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

  late final _$localVersionAtom =
      Atom(name: 'LoginStoreBase.localVersion', context: context);

  @override
  String? get localVersion {
    _$localVersionAtom.reportRead();
    return super.localVersion;
  }

  @override
  set localVersion(String? value) {
    _$localVersionAtom.reportWrite(value, super.localVersion, () {
      super.localVersion = value;
    });
  }

  late final _$isPasswordVisibleAtom =
      Atom(name: 'LoginStoreBase.isPasswordVisible', context: context);

  @override
  bool get isPasswordVisible {
    _$isPasswordVisibleAtom.reportRead();
    return super.isPasswordVisible;
  }

  @override
  set isPasswordVisible(bool value) {
    _$isPasswordVisibleAtom.reportWrite(value, super.isPasswordVisible, () {
      super.isPasswordVisible = value;
    });
  }

  late final _$statusMessageAtom =
      Atom(name: 'LoginStoreBase.statusMessage', context: context);

  @override
  String get statusMessage {
    _$statusMessageAtom.reportRead();
    return super.statusMessage;
  }

  @override
  set statusMessage(String value) {
    _$statusMessageAtom.reportWrite(value, super.statusMessage, () {
      super.statusMessage = value;
    });
  }

  late final _$loginAsyncAction =
      AsyncAction('LoginStoreBase.login', context: context);

  @override
  Future<void> login() {
    return _$loginAsyncAction.run(() => super.login());
  }

  late final _$getVersionAsyncAction =
      AsyncAction('LoginStoreBase.getVersion', context: context);

  @override
  Future<void> getVersion() {
    return _$getVersionAsyncAction.run(() => super.getVersion());
  }

  late final _$LoginStoreBaseActionController =
      ActionController(name: 'LoginStoreBase', context: context);

  @override
  void changePasswordVisibility() {
    final _$actionInfo = _$LoginStoreBaseActionController.startAction(
        name: 'LoginStoreBase.changePasswordVisibility');
    try {
      return super.changePasswordVisibility();
    } finally {
      _$LoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
localVersion: ${localVersion},
isPasswordVisible: ${isPasswordVisible},
statusMessage: ${statusMessage}
    ''';
  }
}
