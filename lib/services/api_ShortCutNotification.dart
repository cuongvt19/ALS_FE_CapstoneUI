
import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart';
import 'package:capstone_ui/Model/getNotification_model.dart';

class ShortCutNotificationService {
  final getListNotiBySupportId =
      "http://als.cosplane.asia/api/ShortCutNotification/GetNotificationBySupporterId?supporterId=";

   Future<List<ShortCutNotification>> getListShortCutNotificationBySupporterId(String supporterId) async {
    final response =
        await get(Uri.parse(getListNotiBySupportId + supporterId));
    print('Respone Status: ${response.statusCode}');
    print('Respone body: ${response.body}');
    if (response.statusCode == 200) {
      
      final List<dynamic> result = jsonDecode(response.body);
      print("result: + ${result.map((e) => ShortCutNotification.fromJson(e)).toList()}");
      return result.map((e) => ShortCutNotification.fromJson(e)).toList();
      
    } else {
      throw Exception("Failed to load ShortCut Notification");
    }
  }

  
  
}