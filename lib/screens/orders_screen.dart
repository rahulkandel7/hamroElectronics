import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamro_electronics/controllers/statusController.dart';
import 'package:hamro_electronics/screens/product_view_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final statusController = Get.put(StatusController());

  String? uid;

  _getUserId() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    var userInfo = _prefs.getString('user');

    var userDecoded = json.decode(userInfo!) as Map<String, dynamic>;

    setState(() {
      uid = userDecoded["userid"];
    });
  }

  @override
  void initState() {
    _getUserId();
    super.initState();
    statusController.fetchStatus(uid.toString());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Orders'),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Active Order',
              ),
              Tab(
                text: 'Completed Order',
              ),
              Tab(
                text: 'Cancelled Order',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            statusController.status
                        .where((p0) =>
                            p0.status == "Pending" || p0.status == "Processing")
                        .toList()
                        .length ==
                    0
                ? const Center(child: Text('No Ordered items yet'))
                : ListView.builder(
                    itemBuilder: (ctx, i) {
                      var stat = statusController.status
                          .where((p0) =>
                              p0.status == "Pending" ||
                              p0.status == "Processing")
                          .toList();
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              ProductViewScreen.routeName,
                              arguments: stat[i].pid);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4,
                                  offset: Offset(4, 4),
                                  color: Colors.grey.shade300,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 80,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                    child: Image.network(
                                      'https://hamroelectronics.com.np/images/product/${stat[i].image}',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          stat[i].pname,
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Status:',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.02,
                                                ),
                                                child: Text(
                                                  stat[i].status,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: statusController.status
                        .where((p0) =>
                            p0.status == "Pending" || p0.status == "Processing")
                        .toList()
                        .length,
                  ),
            statusController.status
                        .where((p0) => p0.status == "Completed")
                        .toList()
                        .length ==
                    0
                ? const Center(child: Text('No Completed Orders yet'))
                : ListView.builder(
                    itemBuilder: (ctx, i) {
                      var stat = statusController.status
                          .where((p0) => p0.status == "Completed")
                          .toList();
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              ProductViewScreen.routeName,
                              arguments: stat[i].pid);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4,
                                  offset: Offset(4, 4),
                                  color: Colors.grey.shade300,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 80,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                    child: Image.network(
                                      'https://hamroelectronics.com.np/images/product/${stat[i].image}',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          stat[i].pname,
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Status:',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.02,
                                                ),
                                                child: Text(
                                                  stat[i].status,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: statusController.status
                        .where((p0) => p0.status == "Completed")
                        .toList()
                        .length,
                  ),
            statusController.status
                        .where((p0) => p0.status == "Cancelled")
                        .toList()
                        .length ==
                    0
                ? const Center(child: Text('No Cancelled items yet'))
                : ListView.builder(
                    itemBuilder: (ctx, i) {
                      var stat = statusController.status
                          .where((p0) => p0.status == "Cancelled")
                          .toList();
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              ProductViewScreen.routeName,
                              arguments: stat[i].pid);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4,
                                  offset: Offset(4, 4),
                                  color: Colors.grey.shade300,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 80,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                    child: Image.network(
                                      'https://hamroelectronics.com.np/images/product/${stat[i].image}',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          stat[i].pname,
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Status:',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.02,
                                                ),
                                                child: Text(
                                                  stat[i].status,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: statusController.status
                        .where((p0) => p0.status == "Cancelled")
                        .toList()
                        .length,
                  ),
          ],
        ),
      ),
    );
  }
}