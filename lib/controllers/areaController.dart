import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/area.dart';

class AreaController extends GetxController {
  var area = <Area>[].obs;

  fetchArea() async {
    final url = Uri.parse("https://hamroelectronics.com.np/api/area");

    final response =
        await http.get(url, headers: {'Accept': 'application/json'});

    final List<Area> _area = [];

    final body = json.decode(response.body) as List;

    body.forEach((a) {
      _area.add(
        Area(
          id: a["id"],
          name: a["areaname"],
          charge: a["charge"],
        ),
      );

      area.value = _area;
    });
  }

  findArea(String name) {
    return area.firstWhere((p0) => p0.name == name);
  }
}
