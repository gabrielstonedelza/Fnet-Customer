import 'dart:convert';

import 'package:fnet_customer/static/app_colors.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'loadingui.dart';

class FetchCustomerYearlyOverAllTransactionByBank extends StatefulWidget {
  const FetchCustomerYearlyOverAllTransactionByBank({Key? key})
      : super(key: key);

  @override
  State<FetchCustomerYearlyOverAllTransactionByBank> createState() =>
      _FetchCustomerYearlyOverAllTransactionByBankState();
}

class _FetchCustomerYearlyOverAllTransactionByBankState
    extends State<FetchCustomerYearlyOverAllTransactionByBank> {
  final storage = GetStorage();
  late String customerNumber = "";
  var _currentSelectedYear = "2023";
  final _formKey = GlobalKey<FormState>();

  late List searchedTransactions = [];
  List years = [
    "2021",
    "2022",
    "2023",
    "2024",
    "2025",
    "2026",
    "2027",
    "2028",
    "2029",
    "2030",
  ];

  String bMonth = "";
  String bYear = "";
  String bBank = "";

  late List allTransactions = [];
  bool isSearching = false;
  late List amounts = [];
  late List amountResults = [];
  bool hasData = false;
  double sum = 0.0;
  double cashReceived = 0.0;
  var items;

  Future<void> fetchAgentCashInTransactionsByMonth() async {
    final url =
        "https://fnetghana.xyz/get_customer_transaction_overall_year/$customerNumber/$bYear/";
    var myLink = Uri.parse(url);
    final response = await http.get(myLink);

    if (response.statusCode == 200) {
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      allTransactions = json.decode(jsonData);
      amounts.assignAll(allTransactions);
      for (var i in amounts) {
        sum = sum + double.parse(i['amount']);
      }
      setState(() {
        hasData = true;
        isSearching = false;
      });
    } else {
      setState(() {
        hasData = false;
        isSearching = false;
      });
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: defaultColor,
          title: const Text(
            "Search Transactions",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: defaultTextColor1),
          ),
        ),
        body: ListView(
          children: [
            const SizedBox(height: 20),
            const Padding(
                padding: EdgeInsets.only(left: 35.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Text("Year",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10),
                            child: DropdownButton(
                              hint: const Text("Years"),
                              isExpanded: true,
                              underline: const SizedBox(),
                              // style: const TextStyle(
                              //     color: Colors.black, fontSize: 20),
                              items: years.map((dropDownStringItem) {
                                return DropdownMenuItem(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem),
                                );
                              }).toList(),
                              onChanged: (newValueSelected) {
                                _onDropDownItemSelectedYear(newValueSelected);
                              },
                              value: _currentSelectedYear,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RawMaterialButton(
                onPressed: () {
                  setState(() {
                    isSearching = true;
                    bYear = _currentSelectedYear;
                  });

                  if (!_formKey.currentState!.validate()) {
                    return;
                  } else {
                    fetchAgentCashInTransactionsByMonth();
                  }
                },
                // child: const Text("Send"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 8,
                fillColor: secondaryColor,
                splashColor: defaultTextColor1,
                child: const Text(
                  "Search",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: defaultTextColor1),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            isSearching
                ? const LoadingUi()
                : SizedBox(
                    height: 520,
                    child: ListView.builder(
                        itemCount: amounts != null ? amounts.length : 0,
                        itemBuilder: (context, i) {
                          items = amounts[i];
                          return Column(
                            children: [
                              // const SizedBox(
                              //   height: 20,
                              // ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 8),
                                child: Card(
                                  color: secondaryColor,
                                  elevation: 12,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  // shadowColor: Colors.pink,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, bottom: 5),
                                    child: ListTile(
                                      title: Row(
                                        children: [
                                          const Text(
                                            "Amount: ",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            "₵${items['amount']}",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                "Agent: ",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                items['agent_username'],
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
                                                "Status: ",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                items['request_status'],
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
                                                items['date_requested'],
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
                                                "Time: ",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                items['time_requested']
                                                    .toString()
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
                        }))
          ],
        ),
        floatingActionButton: !isSearching
            ? FloatingActionButton(
                backgroundColor: primaryColor,
                child: const Text(
                  "Total",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: defaultTextColor1),
                ),
                onPressed: () {
                  Get.defaultDialog(
                    buttonColor: primaryColor,
                    title: "Total",
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
              )
            : Container(),
      ),
    );
  }

  void _onDropDownItemSelectedYear(newValueSelected) {
    setState(() {
      _currentSelectedYear = newValueSelected;
    });
  }
}
