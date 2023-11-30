import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fnet_customer/controllers/customercontroller.dart';
import 'package:fnet_customer/login.dart';
import 'package:fnet_customer/points.dart';
import 'package:fnet_customer/referfriend.dart';
import 'package:fnet_customer/referrals.dart';
import 'package:fnet_customer/requestdeposit.dart';
import 'package:fnet_customer/static/app_colors.dart';
import 'package:fnet_customer/transactionsummary.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'accounts.dart';
import 'carouselcomponent.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final storage = GetStorage();
  late String customerNumber = "";
  final CustomerController controller = Get.find();
  late Timer _timer;
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    if (storage.read("customerNumber") != null) {
      setState(() {
        customerNumber = storage.read("customerNumber");
      });
    }
    final videoId =
        YoutubePlayer.convertUrlToId(controller.defaultCommercialLink);
    _controller = YoutubePlayerController(
        initialVideoId: videoId!,
        flags: const YoutubePlayerFlags(autoPlay: true, loop: true));
    scheduleTimers();
  }

  void scheduleTimers() {
    controller.getAllBankTransactions(customerNumber);
    controller.getAllBankAccounts(customerNumber);
    controller.getAllCustomerReferrals(customerNumber);
    controller.fetchAdmin();
    controller.getAllCommercials();
    controller.getCustomerDetails(customerNumber);
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      controller.getAllBankTransactions(customerNumber);
      controller.getAllBankAccounts(customerNumber);
      controller.getAllCustomerReferrals(customerNumber);
      controller.fetchAdmin();
      controller.getAllCommercials();
      controller.getCustomerDetails(customerNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            customerNumber,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: defaultTextColor1),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  storage.remove("customerNumber");
                  Get.offAll(() => const LoginView());
                },
                icon:
                    const Icon(Icons.login_outlined, color: defaultTextColor1))
          ],
          backgroundColor: defaultColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => const RequestDeposit());
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: SizedBox(
                              height: 110,
                              width: 110,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset("assets/images/deposit.png",
                                        width: 40, height: 40),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Request",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => const TransactionSummary());
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: SizedBox(
                              height: 110,
                              width: 110,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                        "assets/images/data-analysis.png",
                                        width: 40,
                                        height: 40),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Transactions",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => const CustomerAccounts());
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: SizedBox(
                              height: 110,
                              width: 110,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset("assets/images/bank.png",
                                        width: 40, height: 40),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Accounts",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => const CustomerPoints());
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: SizedBox(
                              height: 110,
                              width: 110,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                        "assets/images/customer-loyalty.png",
                                        width: 40,
                                        height: 40),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Points",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => const ReferAFriend());
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: SizedBox(
                              height: 110,
                              width: 110,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset("assets/images/user-2.png",
                                        width: 40, height: 40),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Refer Friend",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => const Referrals());
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: SizedBox(
                              height: 110,
                              width: 110,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset("assets/images/user-2.png",
                                        width: 40, height: 40),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Referrals",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              const MyCarouselComponent(),
              Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                ),
              ),
            ],
          ),
        ));
  }
}
