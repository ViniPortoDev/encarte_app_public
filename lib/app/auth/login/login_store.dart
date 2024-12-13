import 'dart:convert';

import 'package:app_prod_atacado/app/shared/models/user.dart';
import 'package:app_prod_atacado/app/shared/utils/custom_dio.dart';
import 'package:app_prod_atacado/app/shared/utils/logger.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'login_store.g.dart';

class LoginStore = LoginStoreBase with _$LoginStore;

abstract class LoginStoreBase with Store {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @observable
  bool isLoading = false;

  @observable
  String? localVersion;


  @observable
  bool isPasswordVisible = false;

  @observable
  String statusMessage = '';

  @action
  void changePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
  }

  @action
  Future<void> login() async {
    isLoading = true;

   try {
     dio.options.headers['Content-Type'] = 'application/x-www-form-urlencoded';
      final response = await dio.post(
        '/login.php',
        data: {
          'username': usernameController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        //logger.d(json.decode(response.data));
        var data = json.decode(response.data);
        if (data['success'] == false) {
          statusMessage = data['message'];
          isLoading = false;
          return;
        }
        var authorizedVersion = data['version'];
        var forcedUpdate = data['update'];
        if (authorizedVersion != localVersion! && forcedUpdate == 'S') {
          statusMessage = 'Versão do aplicativo desatualizada';
          isLoading = false;
          return;
        }
        var user = User.fromJson(data);
        logger.d('Usuário logado: ${user.username}');
        statusMessage = 'Login efetuado com sucesso';
        Modular.to.pushReplacementNamed('/home', arguments: user);
      } else {
        logger.e('Erro ao efetuar login');
        statusMessage = 'Erro ao efetuar login';
      }
    } catch (e) {
      logger.e('Erro ao efetuar login');
      statusMessage = 'Erro ao efetuar login';
    }
    
    isLoading = false;
  }
  @action
  Future<void> getVersion() async {
    var version = '';
    await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      version = packageInfo.version;
    });
    localVersion = version;
    
  }
}