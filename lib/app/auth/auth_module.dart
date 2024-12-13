import 'package:app_prod_atacado/app/auth/login/login_page.dart';
import 'package:app_prod_atacado/app/auth/login/login_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton(() => LoginStore());
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => const LoginPage());
  }
}
