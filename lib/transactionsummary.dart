import 'package:flutter/material.dart';
import 'package:fnet_customer/controllers/customercontroller.dart';
import 'package:fnet_customer/static/app_colors.dart';
import 'package:fnet_customer/transactionsummarydetail.dart';

import 'package:get/get.dart';

class TransactionSummary extends StatefulWidget {
  const TransactionSummary({Key? key}) : super(key: key);

  @override
  _TransactionSummaryState createState() => _TransactionSummaryState();
}

class _TransactionSummaryState extends State<TransactionSummary> {
  var items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Summary",
            style: TextStyle(color: defaultTextColor1),
          ),
          backgroundColor: defaultColor,
        ),
        body: GetBuilder<CustomerController>(builder: (controller) {
          return ListView.builder(
              itemCount: controller.transactionDates != null
                  ? controller.transactionDates.length
                  : 0,
              itemBuilder: (context, i) {
                items = controller.transactionDates[i];
                return Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return TransactionSummaryDetail(
                              req_date: controller.transactionDates[i]);
                        }));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Card(
                          color: secondaryColor,
                          elevation: 12,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          // shadowColor: Colors.pink,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                            child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Row(
                                  children: [
                                    const Text(
                                      "Date: ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      items,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              });
        }));
  }
}
