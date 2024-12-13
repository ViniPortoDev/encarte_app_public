import 'package:app_prod_atacado/app/auth/login/login_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final LoginStore store = Modular.get<LoginStore>();

  @override
  void initState() {
    super.initState();
    store.getVersion();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: height * 0.15),
                //width: 380.0,
                height: 200.0,
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            store.localVersion != null
                ? Text(
                    'Versão: ${store.localVersion}',
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                    ),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                  key: store.formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: store.usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Usuário',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                            ),
                            filled: true,
                            fillColor: Colors.white70,
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Informe o usuário';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: store.passwordController,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                            ),
                            filled: true,
                            fillColor: Colors.white70,
                            suffixIcon: IconButton(
                              icon: Icon(
                                store.isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  store.changePasswordVisibility();
                                });
                              },
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          obscureText: !store.isPasswordVisible,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Informe a senha';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        Observer(builder: (_) {
                          return Column(children: [
                            store.isLoading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: () {
                                      if (store.formKey.currentState!
                                          .validate()) {
                                        store.login();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 223, 17, 17),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: const Text('Entrar',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                        )),
                                  ),
                            const SizedBox(height: 16.0),
                            Text(store.statusMessage,
                                style: TextStyle(
                                    color:
                                        store.statusMessage.contains('sucesso')
                                            ? Colors.green
                                            : Colors.red)),
                          ]);
                        })
                      ])),
            ),
          ],
        ),
      ),
    );
  }
}
