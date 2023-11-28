import 'package:flutter/material.dart';
import 'package:fnet_customer/controllers/customercontroller.dart';
import 'package:fnet_customer/static/app_colors.dart';
import 'package:get/get.dart';

class Referrals extends StatefulWidget {
  const Referrals({super.key});

  @override
  State<Referrals> createState() => _ReferralsState();
}

class _ReferralsState extends State<Referrals> {
  var items;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultColor,
        title: const Text(
          "My Referrals",
          style: TextStyle(color: defaultTextColor1),
        ),
      ),
      body: GetBuilder<CustomerController>(builder: (controller) {
        return ListView.builder(
            itemCount: controller.customerReferrals != null
                ? controller.customerReferrals.length
                : 0,
            itemBuilder: (context, index) {
              items = controller.customerReferrals[index];
              return Card(
                color: secondaryColor,
                elevation: 12,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Row(
                    children: [
                      const Text("Name: ",
                          style: TextStyle(color: defaultTextColor1)),
                      Text(items['name'],
                          style: const TextStyle(color: defaultTextColor1)),
                    ],
                  ),
                  subtitle: Column(
                    children: [
                      Row(
                        children: [
                          const Text("Phone:",
                              style: TextStyle(color: defaultTextColor1)),
                          Text(items['phone'],
                              style: const TextStyle(color: defaultTextColor1)),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Date Referred: ",
                              style: TextStyle(color: defaultTextColor1)),
                          Text(
                              items['date_created'].toString().split("T").first,
                              style: const TextStyle(color: defaultTextColor1)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            });
      }),
    );
  }
}
