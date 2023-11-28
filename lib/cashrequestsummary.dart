import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fnet_customer/controllers/customercontroller.dart';
import 'package:fnet_customer/loadingui.dart';
import 'package:fnet_customer/static/app_colors.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'cashsupport.dart';

class CashSupportSummary extends StatefulWidget {
  const CashSupportSummary({super.key});

  @override
  State<CashSupportSummary> createState() => _CashSupportSummaryState();
}

class _CashSupportSummaryState extends State<CashSupportSummary> {
  var items;
  var supportItems;
  final storage = GetStorage();
  late String customerNumber = "";
  late double balanceRemaining = 0.0;
  late List customersCashSupportPaid = [];
  bool isLoading = true;
  Future<void> getAllCashSupportPaid() async {
    final profileLink =
        "https://fnetghana.xyz/get_all_customers_cash_support_paid/$customerNumber/";
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
      setState(() {
        isLoading = false;
      });
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (storage.read("customerNumber") != null) {
      setState(() {
        customerNumber = storage.read("customerNumber");
      });
    }
    getAllCashSupportPaid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: defaultColor,
          title: const Text("Cash Support Summary",
              style: TextStyle(color: defaultTextColor1))),
      body: isLoading
          ? const LoadingUi()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  GetBuilder<CustomerController>(builder: (controller) {
                    return SizedBox(
                      height: 150,
                      child: Card(
                        color: secondaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, bottom: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Amount Received:  ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: defaultTextColor1,
                                            fontSize: 17)),
                                    Text("₵${controller.cashSupportAmount}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: defaultTextColor1,
                                            fontSize: 17)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Interest: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: defaultTextColor1,
                                            fontSize: 17)),
                                    Text("₵${controller.cashSupportInterest}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: defaultTextColor1,
                                            fontSize: 17)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Balance: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                            fontSize: 17)),
                                    Text(
                                        "₵${controller.cashSupportAmount - balanceRemaining}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                            fontSize: 17)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  SizedBox(
                    height: 600,
                    child:
                        GetBuilder<CustomerController>(builder: (controller) {
                      return ListView.builder(
                          itemCount: controller.customersCashSupportPaid != null
                              ? controller.customersCashSupportPaid.length
                              : 0,
                          itemBuilder: (context, index) {
                            items = controller.customersCashSupportPaid[index];
                            return Card(
                              color: secondaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("₵${items['amount']}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: defaultTextColor1,
                                            fontSize: 17)),
                                    Row(
                                      children: [
                                        Text(
                                            items["date_added"]
                                                .toString()
                                                .split("T")
                                                .first,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: defaultTextColor1,
                                                fontSize: 12)),
                                        const Text(" / ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: defaultTextColor1,
                                                fontSize: 12)),
                                        Text(
                                            items["date_added"]
                                                .toString()
                                                .split("T")
                                                .last
                                                .split(".")
                                                .first,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: defaultTextColor1,
                                                fontSize: 12)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    }),
                  )
                ],
              ),
            ),
      floatingActionButton: balanceRemaining != 0.0
          ? FloatingActionButton(
              backgroundColor: defaultColor,
              onPressed: () {
                Get.to(() => const RequestCashSupport());
              },
              child: const Icon(Icons.add_circle_outline,
                  color: defaultTextColor1))
          : Container(),
    );
  }
}
