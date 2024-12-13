import 'dart:developer';

import 'package:app_prod_atacado/app/home/product/products_store.dart';
import 'package:app_prod_atacado/app/shared/models/product.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_mobx/flutter_mobx.dart';


class ProductCard extends StatelessWidget {
  final Product product;
  final bool showPrice;
  final ProductsStore store; // Adicione o store como parâmetro

  const ProductCard({
    super.key,
    required this.product,
    required this.showPrice,
    required this.store, // Receba o store pelo construtor
  });

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final isSelected = store.isProductSelected(product); // Verifique se o produto está selecionado

        return InkWell(
          onTap: () {
            store.toggleProductSelection(product); // Alterna a seleção do produto
            log('Produto selecionado: ${product.id}');
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? Colors.red : Colors.red, // Muda a cor da borda se selecionado
                width: isSelected ? 3.0 : 1.5, // Aumenta a espessura da borda se selecionado
              ),
              borderRadius: BorderRadius.circular(12),
              color: isSelected ? Colors.red.withOpacity(0.3) : Colors.transparent, // Vermelho transparente se selecionado
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.center,
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image:
                          '',
                      imageErrorBuilder: (context, error, stackTrace) {
                        return FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image:
                              '',
                          imageErrorBuilder: (context, error, stackTrace) {
                            return FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image:
                                  '',
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/erro.jpg');
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  flex: 2,
                  child: Text(
                    '${product.id} - ${product.description}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 3),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'COD: ${product.id.toString()}',
                            style: const TextStyle(
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'Estoque: ${product.stock.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      product.sold == 0
                          ? const SizedBox()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Valor Vendido: R\$ ${product.sold.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
                showPrice
                    ? Expanded(
                        flex: 1,
                        child: Text(
                          'R\$ ${product.price.toStringAsFixed(2).replaceAll('.', ',')}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ))
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }
}
