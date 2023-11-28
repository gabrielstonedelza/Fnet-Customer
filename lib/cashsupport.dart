import 'package:flutter/material.dart';
import 'package:fnet_customer/sendsms.dart';
import 'package:fnet_customer/static/app_colors.dart';
import 'package:get_storage/get_storage.dart';
import "package:get/get.dart";
import 'controllers/customercontroller.dart';
import 'dashboard.dart';
import 'loadingui.dart';
import 'package:http/http.dart' as http;

class RequestCashSupport extends StatefulWidget {
  const RequestCashSupport({super.key});

  @override
  State<RequestCashSupport> createState() => _RequestCashSupportState();
}

class _RequestCashSupportState extends State<RequestCashSupport> {
  final storage = GetStorage();
  late String customerNumber = "";
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool isPosting = false;
  void _startPosting() async {
    setState(() {
      isPosting = true;
    });
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      isPosting = false;
    });
  }

  final SendSmsController sendSms = SendSmsController();
  final CustomerController controller = Get.find();

  Future<void> referCashSupport() async {
    const depositUrl = "https://fnetghana.xyz/request_cash_support/";
    final myLink = Uri.parse(depositUrl);
    final res = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    }, body: {
      "customer_name": _nameController.text,
      "customer_phone": customerNumber,
      "amount": _amountController.text,
    });
    if (res.statusCode == 201) {
      Get.snackbar(
          "Congratulations", "Request sent.An agent will call you soon.",
          colorText: defaultTextColor1,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
          backgroundColor: snackColor);
      String telnum1 = controller.adminPhone;
      telnum1 = telnum1.replaceFirst("0", '+233');
      sendSms.sendMySms(telnum1, "FNET",
          "Hello Admin,$customerNumber has just requested for a cash support of ₵${_amountController.text}");
      Get.offAll(() => const DashBoard());
    } else {
      Get.snackbar("Error", res.body.toString(),
          colorText: defaultTextColor1,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: snackColor);
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

    _nameController = TextEditingController();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Cash Support",
            style: TextStyle(color: defaultTextColor1)),
        backgroundColor: defaultColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextFormField(
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: const TextStyle(color: defaultTextColor2),
                          focusColor: defaultTextColor2,
                          fillColor: defaultTextColor2,
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: defaultTextColor2, width: 2),
                              borderRadius: BorderRadius.circular(12)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12))),
                      // cursorColor: Colors.black,
                      // style: const TextStyle(color: Colors.black),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter name";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextFormField(
                      controller: _amountController,
                      focusNode: _amountFocusNode,
                      decoration: InputDecoration(
                          labelText: "Amount",
                          labelStyle: const TextStyle(color: defaultTextColor2),
                          focusColor: defaultTextColor2,
                          fillColor: defaultTextColor2,
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: defaultTextColor2, width: 2),
                              borderRadius: BorderRadius.circular(12)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12))),
                      // cursorColor: Colors.black,
                      // style: const TextStyle(color: Colors.black),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter phone";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  isPosting
                      ? const LoadingUi()
                      : RawMaterialButton(
                          onPressed: () {
                            _startPosting();
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }

                            if (!_formKey.currentState!.validate()) {
                              return;
                            } else {
                              referCashSupport();
                            }
                          },
                          // child: const Text("Send"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 8,
                          fillColor: primaryColor,
                          splashColor: defaultColor,
                          child: const Text(
                            "Send",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
