final class ClientModel {
  int? id;
  String name;
  String cpf;
  String phone;
  String email;
  String? responsible;
  DateTime? createdAtt;
  String? secret;

  ClientModel({
    required this.name,
    required this.cpf,
    required this.phone,
    required this.email,
    this.id,
    this.createdAtt,
    this.responsible,
    this.secret,
  });

  Map<String, dynamic> toMap() {
    return {'name': name, 'cpf': cpf, 'phone': phone, 'email': email};
  }

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      name: map['name'] as String,
      cpf: map['cpf'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      id: map['id'] ?? "",
      createdAtt: DateTime.parse(map['createdAt']),
      responsible: map['user']["name"] ?? "",
      secret: map["secret"] ?? "",
    );
  }
}
