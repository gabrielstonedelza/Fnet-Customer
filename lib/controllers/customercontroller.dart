import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class CustomerController extends GetxController {
  bool isLoading = true;
  late List allBankTransactions = [];
  late List allAccounts = [];
  late List customers = [];
  late List customersCashSupport = [];
  late List customersCashSupportPaid = [];
  late List customerNumbers = [];
  late List customerReferrals = [];
  final List customerBanks = [
    "Select bank",
  ];
  late List deCustomer = [];
  final List customerAccounts = ["Select account number"];
  late List accountNames = [];
  late String adminPhone = "";
  late List transactionDates = [];
  late List commercialLinks = [];
  late String defaultCommercialLink = "";
  late String customerPoints = "";
  late List customerDetails = [];
  late double cashSupportAmount = 0.0;
  late double cashSupportInterest = 0.0;
  late double balanceRemaining = 0.0;
  late double balanceNow = 0.0;

  @override
  void onInit() {
    super.onInit();
    getAllCustomers();
    getAllCommercials();
  }

  Future<void> getCustomerDetails(String phone) async {
    try {
      isLoading = true;
      final profileLink = "https://fnetghana.xyz/get_customer_by_phone/$phone/";
      var link = Uri.parse(profileLink);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        customerDetails = jsonData;
        for (var i in customerDetails) {
          customerPoints = i['points'].toString();
        }
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

  Future<void> getAllCommercials() async {
    try {
      isLoading = true;
      const profileLink = "https://fnetghana.xyz/get_commercials/";
      var link = Uri.parse(profileLink);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        commercialLinks = jsonData;
        for (var i in commercialLinks) {
          defaultCommercialLink = i['default_youtube_link'];
        }
        // print(defaultCommercialLink);
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

  Future<void> getAllCustomers() async {
    try {
      isLoading = true;
      const profileLink = "https://fnetghana.xyz/all_customers/";
      var link = Uri.parse(profileLink);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        customers = jsonData;
        for (var i in customers) {
          if (!customerNumbers.contains(i['phone'])) {
            customerNumbers.add(i['phone']);
          }
        }
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

  Future<void> getAllBankTransactions(String phone) async {
    try {
      isLoading = true;
      final profileLink =
          "https://fnetghana.xyz/get_customer_transaction_summary/$phone/";
      var link = Uri.parse(profileLink);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        allBankTransactions = jsonData;
        for (var i in allBankTransactions) {
          if (!transactionDates.contains(i['date_requested'])) {
            transactionDates.add(i['date_requested']);
          }
        }
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

  Future<void> getAllBankAccounts(String phone) async {
    try {
      isLoading = true;

      final profileLink = "https://fnetghana.xyz/get_customer_accounts/$phone/";
      var link = Uri.parse(profileLink);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        allAccounts = jsonData;
        for (var i in allAccounts) {
          if (!customerBanks.contains(i['bank'])) {
            customerBanks.add(i['bank']);
          }
        }
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

  Future<void> getAllCashSupport(String phone) async {
    try {
      isLoading = true;

      final profileLink =
          "https://fnetghana.xyz/get_all_customers_cash_support/$phone/";
      var link = Uri.parse(profileLink);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        customersCashSupport = jsonData;
        for (var i in customersCashSupport) {
          cashSupportAmount = double.parse(i['amount']);
          cashSupportInterest = double.parse(i['interest']);
        }
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

  Future<void> getAllCashSupportPaid(String phone) async {
    try {
      isLoading = true;

      final profileLink =
          "https://fnetghana.xyz/get_all_customers_cash_support_paid/$phone/";
      var link = Uri.parse(profileLink);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        customersCashSupportPaid = jsonData;
        for (var i in customersCashSupportPaid) {
          balanceRemaining = balanceRemaining + double.parse(i['amount']);
        }

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

  Future<void> getAllCustomerReferrals(String phone) async {
    try {
      isLoading = true;
      final profileLink =
          "https://fnetghana.xyz/get_all_customer_referrals/$phone/";
      var link = Uri.parse(profileLink);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        customerReferrals = jsonData;
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

  Future<void> fetchCustomerBankAndNames(
      String customerPhone, String deBank) async {
    try {
      final customerAccountUrl =
          "https://fnetghana.xyz/get_customer_accounts_by_bank/$customerPhone/$deBank/";
      final customerAccountLink = Uri.parse(customerAccountUrl);
      http.Response response = await http.get(customerAccountLink);
      if (response.statusCode == 200) {
        final results = response.body;
        var jsonData = jsonDecode(results);
        deCustomer = jsonData;
        for (var cm in deCustomer) {
          if (!customerAccounts.contains(cm['account_number'])) {
            customerAccounts.add(cm['account_number']);
            accountNames.add(cm['account_name']);
          }
        }
      } else {}
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchAdmin() async {
    const agentUrl = "https://fnetghana.xyz/admin_user";
    final agentLink = Uri.parse(agentUrl);
    http.Response res = await http.get(agentLink);
    if (res.statusCode == 200) {
      final codeUnits = res.body;
      var jsonData = jsonDecode(codeUnits);
      var myUser = jsonData;
      adminPhone = myUser['phone'];
      update();
    }
  }
}
