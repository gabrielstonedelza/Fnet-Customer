import 'package:flutter/material.dart';
import 'package:fnet_customer/requestdeposit.dart';
import 'package:fnet_customer/static/app_colors.dart';
import 'package:get/get.dart';

import 'cashrequestsummary.dart';
import 'cashsupport.dart';

class RequestComponent extends StatelessWidget {
  const RequestComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: defaultColor,
            title: const Text("Request Type",
                style: TextStyle(color: defaultTextColor1))),
        body: Padding(
          padding:
              const EdgeInsets.only(top: 8.0, bottom: 8, left: 18, right: 18),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => const RequestDeposit());
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: SizedBox(
                        height: 200,
                        width: 200,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/images/deposit.png",
                                  width: 70, height: 70),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Request Deposit",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
                const SizedBox(width: 20),
                const Divider(),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const CashSupportSummary());
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: SizedBox(
                        height: 200,
                        width: 200,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/images/money.png",
                                  width: 70, height: 70),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Cash Support",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
