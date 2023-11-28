import 'dart:async';

import 'package:fnet_customer/sendsms.dart';
import 'package:fnet_customer/static/app_colors.dart';
import 'package:get_storage/get_storage.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'dashboard.dart';

class AuthenticateByPhone extends StatefulWidget {
  final otp;
  final customerNumber;
  const AuthenticateByPhone(
      {Key? key, required this.otp, required this.customerNumber})
      : super(key: key);

  @override
  State<AuthenticateByPhone> createState() => _AuthenticateByPhoneState(
      otp: this.otp, customerNumber: this.customerNumber);
}

class _AuthenticateByPhoneState extends State<AuthenticateByPhone> {
  final otp;
  final customerNumber;
  _AuthenticateByPhoneState({required this.otp, required this.customerNumber});
  final storage = GetStorage();

  final formKey = GlobalKey<FormState>();
  static const maxSeconds = 60;
  int seconds = maxSeconds;
  Timer? timer;
  bool isCompleted = false;
  bool isResent = false;
  final SendSmsController sendSms = SendSmsController();

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
                    if (pin?.length == 4 && pin == otp.toString()) {
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
                            sendSms.sendMySms(num, "FNET", "Your code $otp");
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
