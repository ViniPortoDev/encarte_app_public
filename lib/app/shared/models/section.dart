class Section {
  String codigo;
  String descricao;

  Section({
    required this.codigo,
    required this.descricao,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      codigo: json['CODSEC'],
      descricao: json['DESCRICAO'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'descricao': descricao,
    };
  }

  @override
  String toString() {
    return descricao;
  }
}
