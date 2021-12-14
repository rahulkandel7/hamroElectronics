import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:hamro_electronics/models/notification.dart';

class NotificationController extends GetxController {
  var notification = <Notification>[].obs;

  fetchNotification() async {
    final url = Uri.parse("https://hamroelectronics.com.np/api/notification");

    final response =
        await http.get(url, headers: {'Accept': 'application/json'});

    final List<Notification> _notification = [];

    final body = json.decode(response.body) as List;

    body.forEach((a) {
      _notification.insert(
        0,
        Notification(
          id: a["id"],
          title: a["title"],
          description: a["description"],
          date: a["date"],
        ),
      );

      notification.value = _notification;
    });
  }
}
