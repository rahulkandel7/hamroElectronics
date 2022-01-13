import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:hamro_electronics/models/banner.dart';

class BannerController extends GetxController {
  var banner = <Banners>[].obs;

  fetchBanner() async {
    final url =
        Uri.parse("https://hamroelectronics.com.np/api/596810BITS/banner");

    final response =
        await http.get(url, headers: {'Accept': 'application/json'});

    final List<Banners> _banner = [];

    final body = json.decode(response.body) as List;

    body.forEach((a) {
      _banner.add(
        Banners(
          id: a["id"],
          image: a["photopathmob"],
          priority: a["priority"],
        ),
      );

      banner.value = _banner;
    });
  }
}
