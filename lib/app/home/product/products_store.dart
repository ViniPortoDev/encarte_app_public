import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:app_prod_atacado/app/shared/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'dart:ui' as ui;

import 'package:app_prod_atacado/app/shared/models/product.dart';

// Para converter o PDF para imagem

part 'products_store.g.dart';

class ProductsStore = ProductsStoreBase with _$ProductsStore;

abstract class ProductsStoreBase with Store {
  @observable
  bool showPrice = true;

  @observable
  bool generateLoading = false;

  @observable
  List<Product> products = [];

  @observable
  ObservableMap<int, bool> selectedProducts = ObservableMap<int, bool>();

  @action
  void toggleProductSelection(Product product) {
    final isSelected = selectedProducts[product.id] ?? false;
    selectedProducts[product.id] = !isSelected;
  }

  bool isProductSelected(Product product) {
    return selectedProducts[product.id] ?? false;
  }

  @action
  Future<void> generatePdf() async {
    generateLoading = true;
    try {
      var pdf = pw.Document();
      var bannerData = await rootBundle.load('assets/banner.jpeg');
      var bannerImage = pw.MemoryImage(bannerData.buffer.asUint8List());
      Map<int, Uint8List> productImages = {};

      // Carregar imagens dos produtos
      for (var p in products) {
        productImages[p.id] = await getImage(p.id.toString());
      }

      // Filtrar produtos selecionados. Se nenhum estiver selecionado, usar todos.
      List<Product> filteredProducts = selectedProducts.values.contains(true)
          ? products.where((p) => selectedProducts[p.id] == true).toList()
          : products;

      pdf.addPage(pw.MultiPage(
        margin: const pw.EdgeInsets.all(0),
        header: (pw.Context context) {
          return pw.Container(
            height: 150,
            padding: const pw.EdgeInsets.only(bottom: 20),
            child: pw.Image(bannerImage, fit: pw.BoxFit.cover),
          );
        },
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(right: 1.0 * PdfPageFormat.cm),
            child: pw.Text(
              "Preços válidos somente para o dia ${DateFormat('dd/MM/yyyy').format(DateTime.now())} ou enquanto durar os estoques",
              style: const pw.TextStyle(
                color: PdfColors.red,
                fontSize: 10,
              ),
            ),
          );
        },
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Wrap(
                alignment: pw.WrapAlignment.center,
                spacing: 5,
                runSpacing: 20,
                children: List.generate(filteredProducts.length, (index) {
                  var product = filteredProducts[index];
                  var image = productImages[product.id];
                  return pw.Container(
                    margin: const pw.EdgeInsets.only(left: 10, right: 10),
                    width: 160,
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Container(
                          child: image != null
                              ? pw.Image(pw.MemoryImage(image))
                              : pw.Container(),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          '${product.id} - ${product.description}',
                          style: const pw.TextStyle(fontSize: 10),
                          maxLines: 2,
                          overflow: pw.TextOverflow.clip,
                          textAlign: pw.TextAlign.center,
                        ),
                        if (showPrice)
                          pw.Text(
                            'R\$ ${product.price.toStringAsFixed(2).replaceAll('.', ',')}',
                            style: const pw.TextStyle(
                              fontSize: 14,
                              color: PdfColors.green800,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ];
        },
      ));

      // Salvar o PDF e compartilhar
      await Printing.layoutPdf(onLayout: (format) async {
        var file = await pdf.save();
        await Printing.sharePdf(
            bytes: file,
            filename:
                'EncarteElizeu_${DateFormat('ddMMyyyy_hh24mmss').format(DateTime.now())}.pdf');
        return file;
      });
    } catch (e, stackTrace) {
      logger.e('Erro ao gerar PDF: $e', error: e, stackTrace: stackTrace);
    } finally {
      generateLoading = false;
    }
  }

  @action
  Future<List<Uint8List?>> generateImages() async {
    try {
      generateLoading = true;

      // Filtrar produtos selecionados. Se nenhum estiver selecionado, usar todos.
      List<Product> filteredProducts = selectedProducts.values.contains(true)
          ? products.where((p) => selectedProducts[p.id] == true).toList()
          : products;

      // Dividir os produtos em grupos de 9 itens
      const int itemsPerImage = 9;
      List<List<Product>> productChunks = [];
      for (var i = 0; i < filteredProducts.length; i += itemsPerImage) {
        productChunks.add(
          filteredProducts.sublist(
            i,
            i + itemsPerImage > filteredProducts.length
                ? filteredProducts.length
                : i + itemsPerImage,
          ),
        );
      }

      // Carregar o banner
      final ByteData bannerData = await rootBundle.load('assets/banner.jpeg');
      final Uint8List bannerBytes = bannerData.buffer.asUint8List();
      final ui.Codec bannerCodec = await ui.instantiateImageCodec(bannerBytes);
      final ui.FrameInfo bannerFrameInfo = await bannerCodec.getNextFrame();
      final ui.Image bannerImage = bannerFrameInfo.image;

      // Definir dimensões da imagem final
      const double canvasWidth = 1080;
      const double canvasHeight = 1920;
      const double productImageWidth = 320;
      const double productImageHeight = 400;

      // Data atual formatada
      final String currentDate =
          DateFormat('dd/MM/yyyy').format(DateTime.now());

      // Lista para armazenar todas as imagens geradas
      List<Uint8List?> generatedImages = [];

      // Total de páginas
      int totalPages = productChunks.length;

      // Iterar sobre cada grupo de produtos
      for (var pageIndex = 0; pageIndex < productChunks.length; pageIndex++) {
        var productChunk = productChunks[pageIndex];

        // Criar um novo recorder para gerar a imagem
        final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
        final Canvas canvas = Canvas(
          pictureRecorder,
          Rect.fromPoints(
            const Offset(0, 0),
            const Offset(canvasWidth, canvasHeight),
          ),
        );

        // Desenhar o fundo branco
        final Paint paint = Paint()..color = Colors.white;
        canvas.drawRect(
          const Rect.fromLTWH(0, 0, canvasWidth, canvasHeight),
          paint,
        );

        // Desenhar o banner
        logger.i('Desenhando o banner.');
        canvas.drawImageRect(
          bannerImage,
          Rect.fromLTWH(0, 0, bannerImage.width.toDouble(),
              bannerImage.height.toDouble()),
          const Rect.fromLTWH(0, 0, canvasWidth, 320),
          Paint(),
        );

        // Desenhar os produtos
        logger.i('Desenhando os produtos.');
        double xOffset = 20;
        double yOffset = 340;

        for (var product in productChunk) {
          // Carregar a imagem do produto
          final Uint8List productImageBytes =
              await getImage(product.id.toString());
          final ui.Image productImage =
              await decodeImageFromList(productImageBytes);

          // Desenhar a imagem do produto
          canvas.drawImageRect(
            productImage,
            Rect.fromLTWH(0, 0, productImage.width.toDouble(),
                productImage.height.toDouble()),
            Rect.fromLTWH(
                xOffset, yOffset, productImageWidth, productImageHeight),
            Paint(),
          );

          // Desenhar informações do produto
          final TextPainter textPainter = TextPainter(
            text: TextSpan(
              text: '${product.id} - ${product.description}\n',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
              children: [
                if (showPrice)
                  TextSpan(
                    text:
                        'R\$ ${product.price.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24, // Fonte maior para o preço
                      fontWeight: FontWeight.bold, // Negrito para o preço
                    ),
                  ),
              ],
            ),
            textAlign: TextAlign.center,
            textDirection: ui.TextDirection.ltr,
          )..layout(maxWidth: productImageWidth);
          textPainter.paint(
              canvas, Offset(xOffset, yOffset + productImageHeight));

          // Atualizar as coordenadas de X e Y
          xOffset += productImageWidth + 25;
          if (xOffset + productImageWidth > canvasWidth) {
            xOffset = 20;
            yOffset +=
                productImageHeight + 70; // Altura do produto + altura do texto
          }

          // Garantir que os produtos caibam na tela
          if (yOffset + productImageHeight + 70 > canvasHeight) {
            break;
          }
        }

        // Desenhar o texto de "Preços válidos"
        final TextPainter priceValidityTextPainter = TextPainter(
          text: TextSpan(
            text:
                'Preços válidos somente para o dia $currentDate ou enquanto durar os estoques',
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
            ),
          ),
          textAlign: TextAlign.right,
          textDirection: ui.TextDirection.ltr,
        )..layout(maxWidth: canvasWidth - 40);
        priceValidityTextPainter.paint(
            canvas,
            Offset(canvasWidth - priceValidityTextPainter.width - 20,
                canvasHeight - 80));

        // Desenhar a paginação (página atual/total)
        final TextPainter paginationTextPainter = TextPainter(
          text: TextSpan(
            text: '${pageIndex + 1}/$totalPages',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          textAlign: TextAlign.right,
          textDirection: ui.TextDirection.ltr,
        )..layout(maxWidth: canvasWidth - 40);
        paginationTextPainter.paint(
            canvas,
            Offset(canvasWidth - paginationTextPainter.width - 20,
                canvasHeight - 40));

        // Finalizar a gravação da imagem
        final ui.Picture picture = pictureRecorder.endRecording();
        final ui.Image finalImage =
            await picture.toImage(canvasWidth.toInt(), canvasHeight.toInt());
        final ByteData? byteData =
            await finalImage.toByteData(format: ui.ImageByteFormat.png);

        if (byteData == null) {
          generateLoading = false;

          throw Exception('Erro ao converter a imagem para bytes.');
        }

        final Uint8List uint8List = byteData.buffer.asUint8List();
        final now = DateTime.now();
        final formatter = DateFormat('ddMMyyyy_HHmmss');
        final formattedDate = formatter.format(now);

        // Criar a string com a data e hora
        final fileName = 'produtos_$formattedDate';

        // Salvar a imagem na galeria
        logger.i('Salvando a imagem na galeria.');
        await saveImageToGallery(uint8List, fileName);

        // Adicionar a imagem gerada à lista de imagens
        generatedImages.add(uint8List);
      }

      logger.i('Todas as imagens foram geradas e salvas com sucesso!');
      generateLoading = false;

      return generatedImages;
    } catch (e, stackTrace) {
      logger.e('Erro ao gerar ou salvar as imagens',
          error: e, stackTrace: stackTrace);
      generateLoading = false;

      return []; // Retorna uma lista vazia em caso de erro
    }
  }

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> saveImageToGallery(Uint8List imageBytes, String fileName) async {
    try {
      // Verifique se o nome do arquivo tem uma extensão apropriada (.png ou .jpg)
      if (!fileName.endsWith('.png') && !fileName.endsWith('.jpg')) {
        fileName = '$fileName.png';
      }

      // Salvamos o arquivo temporariamente no diretório temporário do app
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/$fileName';
      final file = await File(filePath).writeAsBytes(imageBytes);

      // Usamos o GallerySaver para salvar na galeria
      bool? result =
          await GallerySaver.saveImage(file.path, albumName: "Encartes");

      if (result == true) {
        logger.i('Imagem salva com sucesso!');
      } else {
        logger.e('Falha ao salvar a imagem.');
      }
    } catch (e) {
      logger.e('Erro ao salvar imagem: $e');
    }
  }

  Future<Uint8List> getImage(String codigo) async {
    String urlBase = '';
    var dio = Dio();
    try {
      Response imageResponse = await dio.get('$urlBase$codigo.jpg',
          options: Options(responseType: ResponseType.bytes));
      return imageResponse.data;
    } catch (e) {
      try {
        Response imageResponse = await dio.get('$urlBase$codigo.png',
            options: Options(responseType: ResponseType.bytes));
        return imageResponse.data;
      } catch (e) {
        try {
          Response imageResponse = await dio.get('$urlBase$codigo.jpeg',
              options: Options(responseType: ResponseType.bytes));
          return imageResponse.data;
        } catch (e) {
          return rootBundle
              .load('assets/erro.jpg')
              .then((value) => value.buffer.asUint8List());
        }
      }
    }
  }
}
