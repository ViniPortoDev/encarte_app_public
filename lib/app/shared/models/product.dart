class Product {
  int id;
  String description;
  String section;
  double stock;
  double price;
  double sold;

  Product({
    required this.id,
    required this.description,
    required this.section,
    required this.stock,
    required this.price,
    required this.sold,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.parse(json['CODPROD']),
      description: json['DESCRICAO'],
      section: json['CODSEC'],
      stock: double.parse(json['QTESTGER'] ?? '0'),
      price: double.parse(json['PVENDA1'] ?? '0'),
      sold: double.parse(json['TOTAL'] ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'section': section,
      'stock': stock,
      'price': price,
      'sold': sold,
    };
  }
}
