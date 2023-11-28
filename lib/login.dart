import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fnet_customer/controllers/customercontroller.dart';
import 'package:fnet_customer/sendsms.dart';
import 'package:fnet_customer/static/app_colors.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pinput/pinput.dart';
import 'authenticate.dart';
import 'backgroundwidget.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final CustomerController controller = Get.find();
  final storage = GetStorage();

  late final TextEditingController customerNumberController;
  final FocusNode customerNumberFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  late int oTP = 0;
  final SendSmsController sendSms = SendSmsController();

  generate5digit() {
    var rng = Random();
    var rand = rng.nextInt(9000) + 1000;
    oTP = rand.toInt();
  }

  @override
  void initState() {
    customerNumberController = TextEditingController();
    generate5digit();
    super.initState();
  }

  @override
  void dispose() {
    customerNumberController.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        const BackgroundImage(
          image: "assets/images/pexels-alesia-kozik-6771985.jpg",
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              width: 200,
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      onChanged: (value) {
                        if (value.length == 10 &&
                            controller.customerNumbers.contains(value)) {
                          String num = customerNumberController.text
                              .replaceFirst("0", '+233');
                          sendSms.sendMySms(num, "FNET", "Your code $oTP");
                          storage.write(
                              "customerNumber", customerNumberController.text);
                          Get.offAll(() => AuthenticateByPhone(
                              otp: oTP,
                              customerNumber: customerNumberController.text));
                        } else if (value.length == 10 &&
                            !controller.customerNumbers.contains(value)) {
                          Get.snackbar("Sorry", "Number was not found",
                              colorText: defaultTextColor1,
                              snackPosition: SnackPosition.TOP,
                              duration: const Duration(seconds: 5),
                              backgroundColor: Colors.red);
                        }
                      },
                      controller: customerNumberController,
                      focusNode: customerNumberFocusNode,
                      cursorColor: defaultTextColor1,
                      decoration: InputDecoration(
                          labelText: "Phone Number",
                          labelStyle: const TextStyle(color: defaultTextColor1),
                          focusColor: defaultTextColor1,
                          fillColor: defaultTextColor1,
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: defaultTextColor1, width: 2),
                              borderRadius: BorderRadius.circular(12)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12))),
                      // cursorColor: Colors.black,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    ));
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
