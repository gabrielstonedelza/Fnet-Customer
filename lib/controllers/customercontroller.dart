import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class CustomerController extends GetxController {
  bool isLoading = true;
  late List allBankTransactions = [];
  late List allAccounts = [];
  late List customerNumbers = [];

  Future<void> getAllCustomers() async {
    try {
      isLoading = true;

      const profileLink =
          "https://fnetghana.xyz/get_agents_bank_total_by_date/";
      var link = Uri.parse(profileLink);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        customerNumbers = jsonData;
        update();
      } else {
        if (kDebugMode) {
          print(response.body);
        }
      }
    } catch (e) {
      // Get.snackbar("Sorry","something happened or please check your internet connection",snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> getAllBankTransactions() async {
    try {
      isLoading = true;

      const profileLink =
          "https://fnetghana.xyz/get_agents_bank_total_by_date/";
      var link = Uri.parse(profileLink);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        allBankTransactions = jsonData;
        update();
      } else {
        if (kDebugMode) {
          print(response.body);
        }
      }
    } catch (e) {
      // Get.snackbar("Sorry","something happened or please check your internet connection",snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> getAllBankAccounts() async {
    try {
      isLoading = true;

      const profileLink =
          "https://taxinetghana.xyz/car_sales/get_all_vehicles_for_rent/";
      var link = Uri.parse(profileLink);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        allAccounts = jsonData;
        update();
      } else {
        if (kDebugMode) {
          print(response.body);
        }
      }
    } catch (e) {
      // Get.snackbar("Sorry","something happened or please check your internet connection",snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading = false;
      update();
    }
  }
}
