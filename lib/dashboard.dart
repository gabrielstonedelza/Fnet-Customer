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
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'accounts.dart';
import 'carouselcomponent.dart';
import 'fetchcustomerstransactions.dart';
import 'monthlytotaltransaction.dart';
import 'overalltotalyearlytransactions.dart';

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

  void showOptions() {
    showMaterialModalBottomSheet(
      backgroundColor: Colors.black,
      isDismissible: true,
      context: context,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Card(
          color: Colors.black,
          elevation: 12,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10), topLeft: Radius.circular(10))),
          child: SizedBox(
            height: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 18.0, bottom: 18),
                  child: Center(
                      child: Text("Select on of the following",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: defaultTextColor1))),
                ),
                const SizedBox(
                  height: 20,
                ),
                RawMaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Get.to(() => const FetchCustomerMonthlyTransactionByBank());
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 8,
                  fillColor: primaryColor,
                  splashColor: defaultColor,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Search total by bank,month and year",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white),
                    ),
                  ),
                ),
                RawMaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Get.to(() => const FetchCustomersBankTransactionsYearly());
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 8,
                  fillColor: primaryColor,
                  splashColor: defaultColor,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Search total by bank and year",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white),
                    ),
                  ),
                ),
                RawMaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Get.to(() =>
                        const FetchCustomerYearlyOverAllTransactionByBank());
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 8,
                  fillColor: primaryColor,
                  splashColor: defaultColor,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Get overall yearly total",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
                  showOptions();
                },
                icon: const Icon(Icons.search_outlined,
                    color: defaultTextColor1)),
            IconButton(
                onPressed: () {
                  storage.remove("customerNumber");
                  Get.offAll(() => const LoginView());
                },
                icon:
                    const Icon(Icons.login_outlined, color: defaultTextColor1)),
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
