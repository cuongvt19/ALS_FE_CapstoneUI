class LoginResponeModel {
  String? phoneNumber;
  String? role;
  //String? message;
  LoginResponeModel({this.phoneNumber, this.role});

  factory LoginResponeModel.fromJson(Map<String, dynamic> json) {
    return LoginResponeModel(
      role: json["role"],
      phoneNumber: json["phoneNumber"],
    );
    //message: json["role"] ? "Success" : "Invalid Phone Number or Password");
  }
}

class LoginRequestModel {
  String phoneNumber;
  String password;

  LoginRequestModel({required this.phoneNumber, required this.password});
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'phoneNumber': phoneNumber.trim(),
      'password': password.trim()
    };
    return map;
  }
}
