import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:hamro_electronics/models/order.dart';

class StatusController extends GetxController {
  var status = <Order>[].obs;

  fetchStatus(String uid) async {
    print(uid);
    final url = Uri.parse(
        "https://hamroelectronics.com.np/api/596810BITS/order/show/$uid");

    final response =
        await http.get(url, headers: {'Accept': 'application/json'});

    final body = json.decode(response.body) as List;

    print(response.body);

    final List<Order> _order = [];

    for (var i = 0; i < body.length; i++) {
      _order.add(
        Order(
          pid: body[i][0]["productid"],
          pname: body[i][0]["productname"],
          status: body[i][0]["status"],
          image: body[i][0]["photopath"],
          cancelReason: body[i][0]["reason"],
        ),
      );
    }

    status.value = _order;
  }
}
