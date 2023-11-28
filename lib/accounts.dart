import 'package:flutter/material.dart';
import 'package:fnet_customer/controllers/customercontroller.dart';
import 'package:fnet_customer/static/app_colors.dart';
import 'package:get/get.dart';

class CustomerAccounts extends StatefulWidget {
  const CustomerAccounts({super.key});

  @override
  State<CustomerAccounts> createState() => _CustomerAccountsState();
}

class _CustomerAccountsState extends State<CustomerAccounts> {
  var items;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My Accounts",
              style: TextStyle(color: defaultTextColor1)),
          backgroundColor: defaultColor,
        ),
        body: GetBuilder<CustomerController>(builder: (controller) {
          return ListView.builder(
              itemCount: controller.allAccounts != null
                  ? controller.allAccounts.length
                  : 0,
              itemBuilder: (context, index) {
                items = controller.allAccounts[index];
                return Card(
                  color: secondaryColor,
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Row(
                      children: [
                        const Text("Bank : ",
                            style: TextStyle(color: defaultTextColor1)),
                        Text(items['bank'],
                            style: TextStyle(color: defaultTextColor1)),
                      ],
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            const Text("Acc No : ",
                                style: TextStyle(color: defaultTextColor1)),
                            Text(items['account_number'],
                                style: TextStyle(color: defaultTextColor1)),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Acc Name: ",
                                style: TextStyle(color: defaultTextColor1)),
                            Text(items['account_name'],
                                style: TextStyle(color: defaultTextColor1)),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Date Added: "),
                            Text(
                                items['date_added'].toString().split("T").first,
                                style: TextStyle(color: defaultTextColor1)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        }));
  }
}
