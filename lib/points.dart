import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fnet_customer/controllers/customercontroller.dart';
import 'package:fnet_customer/dashboard.dart';
import 'package:fnet_customer/loadingui.dart';
import 'package:fnet_customer/sendsms.dart';
import 'package:fnet_customer/static/app_colors.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:http/http.dart' as http;

class CustomerPoints extends StatefulWidget {
  const CustomerPoints({super.key});

  @override
  State<CustomerPoints> createState() => _CustomerPointsState();
}

class _CustomerPointsState extends State<CustomerPoints> {
  final storage = GetStorage();
  late String customerNumber = "";
  void showPointsInformation() {
    showMaterialModalBottomSheet(
      backgroundColor: Colors.black,
      isDismissible: true,
      context: context,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: const Card(
          color: Colors.black,
          elevation: 12,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10), topLeft: Radius.circular(10))),
          child: SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 18.0, bottom: 18),
                  child: Center(
                      child: Text("Points Description",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: defaultTextColor1))),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text("50:  ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: defaultTextColor1)),
                    Text("Airtime",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: defaultTextColor1)),
                  ],
                ),
                Row(
                  children: [
                    Text("Greater than 50:  ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: defaultTextColor1)),
                    Text("Melcom Coupon worth ₵100",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: defaultTextColor1)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isPosting = false;
  void _startPosting() async {
    setState(() {
      isPosting = true;
    });
    await Future.delayed(const Duration(seconds: 4));
    setState(() {
      isPosting = false;
    });
  }

  final SendSmsController sendSms = SendSmsController();
  final CustomerController controller = Get.find();

  late double pointsTotal = 0.0;
  late List customerPoints = [];
  bool isLoading = true;

  Future<void> getAllCustomerPoints() async {
    final profileLink =
        "https://fnetghana.xyz/get_all_customer_points/$customerNumber/";
    var link = Uri.parse(profileLink);
    http.Response response = await http.get(link, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    });
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      customerPoints = jsonData;
      for (var i in customerPoints) {
        pointsTotal = pointsTotal + double.parse(i['points']);
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

  Future<void> redeemPoints() async {
    final profileLink = "https://fnetghana.xyz/redeem_points/$customerNumber/";
    var link = Uri.parse(profileLink);
    http.Response response = await http.get(link, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    });
    if (response.statusCode == 200) {
      Get.offAll(() => const DashBoard());
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
    getAllCustomerPoints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                showPointsInformation();
              },
              icon: const Icon(Icons.info_outline, color: defaultTextColor1),
            )
          ],
          backgroundColor: defaultColor,
          title: const Text("My Points",
              style: TextStyle(color: defaultTextColor1))),
      body: isLoading
          ? const LoadingUi()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/earning.png",
                          width: 50, height: 50),
                      const SizedBox(
                        width: 30,
                      ),
                      GetBuilder<CustomerController>(builder: (controller) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: Text("₵$pointsTotal",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30)),
                        );
                      })
                    ],
                  ),
                ),
                isPosting
                    ? const LoadingUi()
                    : GetBuilder<CustomerController>(builder: (controller) {
                        return RawMaterialButton(
                          onPressed: () {
                            _startPosting();
                            if (pointsTotal < 50) {
                              Get.snackbar("Redeem Error",
                                  "Sorry, you need 50 or more points in order to redeem.",
                                  colorText: defaultTextColor1,
                                  snackPosition: SnackPosition.BOTTOM,
                                  duration: const Duration(seconds: 5),
                                  backgroundColor: Colors.red);
                            } else {
                              if (pointsTotal == 50) {
                                String telnum1 = controller.adminPhone;
                                telnum1 = telnum1.replaceFirst("0", '+233');
                                sendSms.sendMySms(telnum1, "FNET",
                                    "Hello Admin,$customerNumber has requested to redeem their $pointsTotal points for Airtime.");
                                Get.snackbar("Redeem Success",
                                    "Your request to redeem points for airtime has been sent,an agent will call you soon.Thank",
                                    colorText: defaultTextColor1,
                                    snackPosition: SnackPosition.BOTTOM,
                                    duration: const Duration(seconds: 5),
                                    backgroundColor: snackColor);
                                redeemPoints();
                              }
                              if (pointsTotal > 50) {
                                String telnum1 = controller.adminPhone;
                                telnum1 = telnum1.replaceFirst("0", '+233');
                                sendSms.sendMySms(telnum1, "FNET",
                                    "Hello Admin,$customerNumber has requested to redeem their pointsTotal points for Melcom Coupon.");
                                Get.snackbar("Redeem Success",
                                    "Your request to redeem points for Melcom Coupon has been sent,an agent will call you soon.Thank",
                                    colorText: defaultTextColor1,
                                    snackPosition: SnackPosition.BOTTOM,
                                    duration: const Duration(seconds: 5),
                                    backgroundColor: snackColor);
                                redeemPoints();
                              }
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 8,
                          fillColor: defaultTextColor2,
                          splashColor: defaultColor,
                          child: const Text(
                            "Redeem",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        );
                      })
              ],
            ),
    );
  }
}
