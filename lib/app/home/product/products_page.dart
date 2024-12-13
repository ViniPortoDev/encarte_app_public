import 'package:app_prod_atacado/app/home/product/products_store.dart';
import 'package:app_prod_atacado/app/home/product/widgets/product_card.dart';
import 'package:app_prod_atacado/app/shared/models/product.dart';
import 'package:app_prod_atacado/app/shared/models/user.dart';
import 'package:app_prod_atacado/app/shared/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class ProductsPage extends StatefulWidget {
  final List<Product> products;
  final User user;

  const ProductsPage({super.key, required this.products, required this.user});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late ProductsStore store;
  final WidgetsToImageController imageController = WidgetsToImageController();

  @override
  void initState() {
    super.initState();
    store = Modular.get<ProductsStore>();
    store.products = widget.products;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    int itemsPerRow = (width / 200).floor();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Modular.to.pop();
          },
        ),
        title: const Text('Produtos'),
        actions: <Widget>[
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
      body: Observer(
        builder: (context) {
          if (store.generateLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Switch(
                      value: store.showPrice,
                      onChanged: (value) {
                        setState(() {
                          store.showPrice = value;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Mostrar Preço',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Expanded(
                  child: WidgetsToImage(
                    controller: imageController,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: itemsPerRow,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: width > 400 ? 0.7 : 1.3,
                          ),
                          itemCount: widget.products.length,
                          itemBuilder: (context, index) {
                            final product = widget.products[index];
                            return ProductCard(
                              product: product,
                              showPrice: store.showPrice,
                              store: store,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: customFloactingButton(
        store,
        context,
        imageController,
      ),
    );
  }
}

Widget customFloactingButton(
  ProductsStore store,
  BuildContext context,
  WidgetsToImageController imageController,
) {
  return SpeedDial(
    animatedIcon: AnimatedIcons.menu_close,
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    overlayColor: Colors.black,
    overlayOpacity: 0.5,
    children: [
      SpeedDialChild(
        child: const Icon(
          Icons.image,
          color: Colors.white,
        ),
        backgroundColor: Colors.lightBlue,
        label: 'Gerar Imagem',
        onTap: () async {
          try {
            store.generateLoading = true;
            await imageController.capture();

            await store.generateImages();
            store.generateLoading = false;

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text('Imagens geradas com sucesso!'),
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text('Erro ao gerar imagem'),
              ),
            );
            logger.e('Erro ao gerar imagem: $e');
          }
        },
      ),
      SpeedDialChild(
        child: const Icon(Icons.picture_as_pdf, color: Colors.white),
        backgroundColor: Colors.red,
        label: 'Gerar PDF',
        onTap: () {
          try {
            store.generatePdf();
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Pdf gerado com sucesso!'),
            );
          } catch (e) {
            store.generatePdf();
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Erro ao gerar pdf!'),
            );
            logger.e('Erro ao gerar pdf: $e');
          }
        },
      ),
    ],
  );
}
