import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fnet_customer/static/app_colors.dart';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../loadingui.dart';

class TransactionSummaryDetail extends StatefulWidget {
  final req_date;
  const TransactionSummaryDetail({Key? key, this.req_date}) : super(key: key);

  @override
  _TransactionSummaryDetailState createState() =>
      _TransactionSummaryDetailState(req_date: this.req_date);
}

class _TransactionSummaryDetailState extends State<TransactionSummaryDetail> {
  final req_date;
  _TransactionSummaryDetailState({required this.req_date});
  final storage = GetStorage();
  late String customerNumber = "";
  bool hasToken = false;
  late String uToken = "";
  late List allTransactions = [];
  bool isLoading = true;
  late var items;
  late List transactions = [];
  late List amountResults = [];
  late List requestDates = [];
  double sum = 0.0;

  Future<void> fetchCustomerTransactions() async {
    final url =
        "https://fnetghana.xyz/get_customer_transaction_summary/$customerNumber/";
    var myLink = Uri.parse(url);
    final response = await http.get(myLink);

    if (response.statusCode == 200) {
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      allTransactions = json.decode(jsonData);
      transactions.assignAll(allTransactions);
      for (var i in transactions) {
        if (i['date_requested'] == req_date) {
          requestDates.add(i);
          sum = sum + double.parse(i['amount']);
        }
      }
    }

    setState(() {
      isLoading = false;
      allTransactions = allTransactions;
      requestDates = requestDates;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (storage.read("customerNumber") != null) {
      setState(() {
        customerNumber = storage.read("customerNumber");
      });
    }
    fetchCustomerTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultColor,
        title: Text("Transactions for $req_date",
            style: const TextStyle(color: defaultTextColor1)),
      ),
      body: SafeArea(
          child: isLoading
              ? const LoadingUi()
              : ListView.builder(
                  itemCount: requestDates != null ? requestDates.length : 0,
                  itemBuilder: (context, i) {
                    items = requestDates[i];
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Card(
                            color: secondaryColor,
                            elevation: 12,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            // shadowColor: Colors.pink,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, bottom: 10),
                              child: ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Row(
                                    children: [
                                      const Text(
                                        "Amount: ",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        items['amount'],
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Bank: ",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          items['bank'],
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Date: ",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          items['date_requested']
                                              .toString()
                                              .split("T")
                                              .first,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Time : ",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          items['date_requested']
                                              .toString()
                                              .split("T")
                                              .last
                                              .split(".")
                                              .first,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  })),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: const Text(
          "Total",
          style:
              TextStyle(color: defaultTextColor1, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Get.defaultDialog(
            buttonColor: primaryColor,
            title: "Bank Deposit Total",
            middleText: "$sum",
            confirm: RawMaterialButton(
                shape: const StadiumBorder(),
                fillColor: primaryColor,
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  "Close",
                  style: TextStyle(color: Colors.white),
                )),
          );
        },
      ),
    );
  }
}
