class Supplier {
  String id;
  String name;
  String cnpj;
  String fantasyName;

  Supplier({
    required this.id,
    required this.name,
    required this.cnpj,
    required this.fantasyName,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['CODFORNEC'],
      name: json['FORNECEDOR'],
      cnpj: json['CGC'],
      fantasyName: json['FANTASIA'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cnpj': cnpj,
      'fantasia': fantasyName,
    };
  }

  @override
  toString() {
    return name;
  }
}
