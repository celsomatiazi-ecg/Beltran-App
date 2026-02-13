class SignupModel {
  String? name;
  String? identification;
  String? oab;
  String? email;
  String? phoneNumber;
  String? password;

  SignupModel({
    this.name,
    this.identification,
    this.oab,
    this.email,
    this.phoneNumber,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      "cpf": identification,
      "oab": oab,
      "name": name,
      "email": email,
      "phone": phoneNumber,
    };
  }
}
