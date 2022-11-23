import 'dart:convert';
import 'package:capstone_ui/Model/UpdateDeviceTokenMobile.dart';
import 'package:capstone_ui/Model/login_model.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class UserService {
  static bool authenticated = false;

  Future<LoginResponeModel> login(LoginRequestModel requestModel) async {
    //String url = "https://reqres.in/api/login";
    String url = "https://als.cosplane.asia/api/user/LoginUserMobile";

    // final response= await http.post(Uri.parse(url), body: requestModel.toJson());
    // if(response.statusCode == 200 || response.statusCode == 400){
    //   return LoginResponeModel.fromJson(json.decode(response.body));
    // }else{
    //   throw Exception('Lỗi dữ liệu');
    // }

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestModel.toJson()),
    );
    if (response.statusCode == HttpStatus.ok) {
      UserService.authenticated = true;
      return LoginResponeModel.fromJson(json.decode(response.body));
    } else {
      UserService.authenticated = false;
      throw Exception('Lỗi dữ liệu');
    }
  }

  Future<UpdateDevicetokenMobileResponse> updateDeviceTokenMobile(
      UpdateDevicetokenMobileRequest requestModel) async {
    String url = "https://als.cosplane.asia/api/user/UpdateDeviceMobileToken";

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestModel.toJson()),
    );
    if (response.statusCode == HttpStatus.ok) {
      return UpdateDevicetokenMobileResponse.fromJson(
          json.decode(response.body));
    } else {
      throw Exception('Lỗi dữ liệu');
    }
  }

  bool Logout(){
     authenticated=false;
    return authenticated;
  }
  bool isUserAuthenticated() {
    return authenticated;
  }
}
