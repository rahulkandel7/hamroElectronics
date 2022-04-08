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

    print(userDecoded);

    setState(() {
      uid = userDecoded["id"].toString();
    });
  }

  @override
  void initState() {
    _getUserId();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: const Text(
            'My Orders',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          bottom: const TabBar(
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
        body: FutureBuilder(
          future: statusController.fetchStatus(uid.toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return TabBarView(
                children: [
                  statusController.status
                              .where((p0) =>
                                  p0.status == "Pending" ||
                                  p0.status == "Processing")
                              .toList()
                              .length ==
                          0
                      ? Center(
                          child: Text(
                          'No Ordered items yet',
                          style: Theme.of(context).textTheme.subtitle1,
                        ))
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
                                    color: Theme.of(context).backgroundColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4,
                                        offset: Offset(4, 4),
                                        color: Theme.of(context).shadowColor,
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
                                          padding:
                                              const EdgeInsets.only(left: 18.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(stat[i].pname,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Status:',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        left: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.02,
                                                      ),
                                                      child: Text(
                                                        stat[i].status,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText2,
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
                                  p0.status == "Pending" ||
                                  p0.status == "Processing")
                              .toList()
                              .length,
                        ),
                  statusController.status
                              .where((p0) => p0.status == "Completed")
                              .toList()
                              .length ==
                          0
                      ? Center(
                          child: Text(
                          'No Completed Orders yet',
                          style: Theme.of(context).textTheme.subtitle1,
                        ))
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
                                    color: Theme.of(context).backgroundColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4,
                                        offset: Offset(4, 4),
                                        color: Theme.of(context).shadowColor,
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
                                          padding:
                                              const EdgeInsets.only(left: 18.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(stat[i].pname,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Status:',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        left: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.02,
                                                      ),
                                                      child: Text(
                                                        stat[i].status,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText2,
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
                      ? Center(
                          child: Text(
                          'No Cancelled items yet',
                          style: Theme.of(context).textTheme.subtitle1,
                        ))
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
                                    color: Theme.of(context).backgroundColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4,
                                        offset: Offset(4, 4),
                                        color: Theme.of(context).shadowColor,
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
                                          padding:
                                              const EdgeInsets.only(left: 18.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(stat[i].pname,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Status:',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        left: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.02,
                                                      ),
                                                      child: Text(
                                                        stat[i].status,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText2,
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
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
