class Client {
  String id;
  String name;
  String cnpj;
  String fantasyName;

  Client({required this.id, required this.name, required this.cnpj, required this.fantasyName});

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['CODCLI'],
      name: json['CLIENTE'],
      cnpj: json['CGCENT'],
      fantasyName: json['FANTASIA'] ?? '',
    );
  }
}