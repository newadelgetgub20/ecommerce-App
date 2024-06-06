import 'package:ecommerce_mobile_app/screen/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthenticationController extends GetxController {
  final isLoading = false.obs;
  final token = ''.obs;
  final box = GetStorage();

  Future<void> login({
    required String username,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      var data = {
        'username': username,
        'password': password,
      };

      var response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/login'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        token.value = json.decode(response.body)['token'];
        box.write('token', token.value);
        
        // Retrieve the URI from the response
        final String uri = json.decode(response.body)['uri']; // Assuming 'uri' is returned

        Get.offAll(() => HomeScreen(uri: uri));
      } else {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        );
        print(json.decode(response.body));
      }
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }
}
