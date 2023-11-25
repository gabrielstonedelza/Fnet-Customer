import 'dart:async';
import 'dart:math';

import 'package:fnet_customer/sendsms.dart';
import 'package:fnet_customer/static/app_colors.dart';
import 'package:get_storage/get_storage.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:pinput/pinput.dart';

import 'dashboard.dart';

class AuthenticateByPhone extends StatefulWidget {
  const AuthenticateByPhone({Key? key}) : super(key: key);

  @override
  State<AuthenticateByPhone> createState() => _AuthenticateByPhoneState();
}

class _AuthenticateByPhoneState extends State<AuthenticateByPhone> {
  final storage = GetStorage();
  late String customerNumber = "";

  late int oTP = 0;
  final SendSmsController sendSms = SendSmsController();

  generate5digit() {
    var rng = Random();
    var rand = rng.nextInt(9000) + 1000;
    oTP = rand.toInt();
  }

  final formKey = GlobalKey<FormState>();
  static const maxSeconds = 60;
  int seconds = maxSeconds;
  Timer? timer;
  bool isCompleted = false;
  bool isResent = false;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        stopTimer(reset: false);
        setState(() {
          isCompleted = true;
        });
      }
    });
  }

  void resetTimer() {
    setState(() {
      seconds = maxSeconds;
    });
  }

  void stopTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    timer?.cancel();
  }

  Timer? myTimer;

  @override
  void initState() {
    super.initState();
    startTimer();
    generate5digit();
    if (storage.read("customerNumber") != null) {
      setState(() {
        customerNumber = storage.read("customerNumber");
      });
    }
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed.
    myTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: shadow,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Lottie.asset(
                  "assets/images/74569-two-factor-authentication.json",
                  width: 300,
                  height: 300)),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                      "A code was sent to your phone,please enter the code here.",
                      style: TextStyle(color: defaultTextColor1))),
            ),
          ),
          Expanded(
            child: Center(
              child: Form(
                key: formKey,
                child: Pinput(
                  defaultPinTheme: defaultPinTheme,
                  androidSmsAutofillMethod:
                      AndroidSmsAutofillMethod.smsRetrieverApi,
                  validator: (pin) {
                    if (pin?.length == 4 && pin == oTP.toString()) {
                      storage.write("phoneAuthenticated", "Authenticated");

                      Get.offAll(() => const DashBoard());
                    } else {
                      Get.snackbar("Code Error", "you entered an invalid code",
                          colorText: defaultTextColor1,
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: warning,
                          duration: const Duration(seconds: 5));
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Didn't receive code?",
                      style: TextStyle(color: defaultTextColor1)),
                  const SizedBox(
                    width: 20,
                  ),
                  isCompleted
                      ? TextButton(
                          onPressed: () {
                            String num =
                                customerNumber.replaceFirst("0", '+233');
                            sendSms.sendMySms(num, "FNET", "Your code $oTP");

                            Get.snackbar("Check Phone", "code was sent again",
                                backgroundColor: snackBackground,
                                colorText: defaultTextColor1,
                                duration: const Duration(seconds: 5));
                            startTimer();
                            resetTimer();
                            setState(() {
                              isResent = true;
                              isCompleted = false;
                            });
                          },
                          child: const Text("Resend Code",
                              style: TextStyle(color: snackBackground)),
                        )
                      : Text("00:${seconds.toString()}",
                          style: const TextStyle(color: defaultTextColor1)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
        fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(20),
    ),
  );
}
