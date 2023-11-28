import 'package:flutter/material.dart';
import 'package:fnet_customer/controllers/customercontroller.dart';
import 'package:fnet_customer/dashboard.dart';
import 'package:fnet_customer/loadingui.dart';
import 'package:fnet_customer/sendsms.dart';
import 'package:fnet_customer/static/app_colors.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RequestDeposit extends StatefulWidget {
  const RequestDeposit({super.key});

  @override
  State<RequestDeposit> createState() => _RequestDepositState();
}

class _RequestDepositState extends State<RequestDeposit> {
  final SendSmsController sendSms = SendSmsController();
  final storage = GetStorage();
  late String customerNumber = "";
  bool isPosting = false;
  final _formKey = GlobalKey<FormState>();
  var _currentSelectedBank = "Select bank";
  final CustomerController controller = Get.find();
  late final TextEditingController _amountController;

  void _startPosting() async {
    setState(() {
      isPosting = true;
    });
    await Future.delayed(const Duration(seconds: 4));
    setState(() {
      isPosting = false;
    });
  }

  Future<void> processDeposit() async {
    const depositUrl = "https://fnetghana.xyz/customer_request_deposit/";
    final myLink = Uri.parse(depositUrl);
    final res = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    }, body: {
      "bank": _currentSelectedBank,
      "customer_phone": customerNumber,
      "amount": _amountController.text,
    });
    if (res.statusCode == 201) {
      Get.snackbar("Congratulations", "Request sent for approval",
          colorText: defaultTextColor1,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: snackColor);
      if (_currentSelectedBank == "Ecobank") {
        processCustomerPoints(2.0);
      } else {
        processCustomerPoints(1.0);
      }
      String telnum1 = controller.adminPhone;
      telnum1 = telnum1.replaceFirst("0", '+233');
      sendSms.sendMySms(telnum1, "FNET",
          "Hello Admin,$customerNumber just made a bank deposit request of GHC${_amountController.text}.");

      String telnum = customerNumber;
      telnum = telnum.replaceFirst("0", '+233');
      sendSms.sendMySms(telnum, "FNET",
          "Hello,your request deposit of ${_amountController.text} into your $_currentSelectedBank is sent for processing,please wait, an agent will call you.Thank you.");

      Get.offAll(() => const DashBoard());
    } else {
      Get.snackbar("Request Error", res.body.toString(),
          colorText: defaultTextColor1,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: snackColor);
    }
  }

  Future<void> processCustomerPoints(double points) async {
    const depositUrl = "https://fnetghana.xyz/add_customer_points/";
    final myLink = Uri.parse(depositUrl);
    final res = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    }, body: {
      "phone": customerNumber,
      "points": points.toString(),
    });
    if (res.statusCode == 201) {
      String telnum = customerNumber;
      telnum = telnum.replaceFirst("0", '+233');
      sendSms.sendMySms(
          telnum, "FNET", "Hello,you have gotten $points for this request");
    } else {
      Get.snackbar("Request Error", res.body.toString(),
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
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Request Deposit",
              style: TextStyle(color: defaultTextColor1)),
          backgroundColor: defaultColor,
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10),
                            child: DropdownButton(
                              hint: const Text("Select bank"),
                              isExpanded: true,
                              underline: const SizedBox(),
                              // style: const TextStyle(
                              //     color: Colors.black, fontSize: 20),
                              items: controller.customerBanks
                                  .map((dropDownStringItem) {
                                return DropdownMenuItem(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem),
                                );
                              }).toList(),
                              onChanged: (newValueSelected) {
                                controller.fetchCustomerBankAndNames(
                                    customerNumber,
                                    newValueSelected.toString());
                                _onDropDownItemSelectedBank(newValueSelected);
                              },
                              value: _currentSelectedBank,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: TextFormField(
                          controller: _amountController,
                          cursorColor: primaryColor,
                          cursorRadius: const Radius.elliptical(10, 10),
                          cursorWidth: 10,
                          decoration: InputDecoration(
                              labelText: "Enter amount",
                              labelStyle:
                                  const TextStyle(color: secondaryColor),
                              focusColor: primaryColor,
                              fillColor: primaryColor,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: primaryColor, width: 2),
                                  borderRadius: BorderRadius.circular(12)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter amount";
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
                                  if (_currentSelectedBank == "Select bank") {
                                    Get.snackbar("Bank Error",
                                        "Please select customers bank from the list",
                                        colorText: Colors.white,
                                        backgroundColor: Colors.red,
                                        snackPosition: SnackPosition.BOTTOM);

                                    return;
                                  } else {
                                    Get.snackbar(
                                        "Please wait", "sending your request",
                                        colorText: defaultTextColor1,
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: snackColor);
                                    processDeposit();
                                  }
                                }
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 8,
                              fillColor: primaryColor,
                              splashColor: defaultColor,
                              child: const Text(
                                "Request",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            )
                    ],
                  )),
            )
          ],
        ));
  }

  void _onDropDownItemSelectedBank(newValueSelected) {
    setState(() {
      _currentSelectedBank = newValueSelected;
    });
  }
}
