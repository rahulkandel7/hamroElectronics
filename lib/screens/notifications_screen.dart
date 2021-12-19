import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamro_electronics/controllers/notificationController.dart';

class NotificationScreen extends StatelessWidget {
  static const routeName = '/notifications';

  final notificationController = Get.put(NotificationController());

  Future<void> _onrefresh() async {
    await notificationController.fetchNotification();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: FutureBuilder(
        future: notificationController.fetchNotification(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              child: RefreshIndicator(
                color: Colors.indigo,
                onRefresh: () => _onrefresh(),
                child: SizedBox(
                  height: mediaQuery.height * 0.9,
                  child: Obx(
                    () {
                      return ListView.builder(
                        itemBuilder: (ctx, i) {
                          return Padding(
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
                              child: Column(
                                children: [
                                  // SizedBox(
                                  //   width: 80,
                                  //   child: ClipRRect(
                                  //     borderRadius: BorderRadius.circular(
                                  //       10,
                                  //     ),
                                  //     child: Image.asset(
                                  //       'assets/2.jpeg',
                                  //     ),
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: mediaQuery.width * 0.02,
                                        vertical: mediaQuery.height * 0.01),
                                    child: SizedBox(
                                      width: mediaQuery.width * 0.9,
                                      child: Text(
                                        notificationController
                                            .notification[i].title,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: mediaQuery.width * 0.02,
                                        bottom: mediaQuery.height * 0.01),
                                    child: SizedBox(
                                      width: mediaQuery.width * 0.9,
                                      child: Text(
                                        notificationController
                                            .notification[i].description,
                                        maxLines: 4,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: mediaQuery.width * 0.02,
                                        bottom: mediaQuery.height * 0.01),
                                    child: SizedBox(
                                      width: mediaQuery.width * 0.9,
                                      child: Text(
                                        notificationController
                                            .notification[i].date,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: notificationController.notification.length,
                      );
                    },
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 1.0,
              ),
            );
          }
        },
      ),
    );
  }
}
