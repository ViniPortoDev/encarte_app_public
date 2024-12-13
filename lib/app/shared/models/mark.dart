class Mark {
  String codMarca;
  String marca;

  Mark({
    required this.codMarca,
    required this.marca,
  });

  factory Mark.fromJson(Map<String, dynamic> json) {
    return Mark(
      codMarca: json['CODMARCA'],
      marca: json['MARCA'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CODMARCA': codMarca,
      'MARCA': marca,
    };
  }
}
