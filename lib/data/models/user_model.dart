class UserModel {
  String? name;
  String? identification;
  String? oab;
  String? email;
  String? phoneNumber;

  UserModel({
    this.name,
    this.identification,
    this.oab,
    this.email,
    this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {"name": name, "email": email, "phone": phoneNumber};
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      identification: map['cpf'] as String,
      oab: map['oab'] as String,
      email: map['email'] as String,
      phoneNumber: map['phone'] as String,
    );
  }
}
