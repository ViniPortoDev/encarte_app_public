import 'package:app_prod_atacado/app/auth/auth_module.dart';
import 'package:app_prod_atacado/app/home/home_page.dart';
import 'package:app_prod_atacado/app/home/home_store.dart';
import 'package:app_prod_atacado/app/home/product/products_page.dart';
import 'package:app_prod_atacado/app/home/product/products_store.dart';

import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton(() => HomeStore());
    i.addLazySingleton(() => ProductsStore());
  }

  @override
  void routes(r) {
    r.module('/', module: AuthModule());
    r.child('/home', child: (_) => HomePage(user: r.args.data));
    r.child('/products',
        child: (_) =>
            ProductsPage(products: r.args.data[0], user: r.args.data[1]));
  }
}
