import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/toppicks.dart';

class ToppicksController extends GetxController {
  var toppicks = <Toppicks>[].obs;

  fetchToppicks() async {
    var url = Uri.parse("https://www.hamroelectronics.com.np/api/toppicks");

    final response =
        await http.get(url, headers: {'Accept': 'application/json'});

    final body = json.decode(response.body) as List;

    final List<Toppicks> _toppicks = [];

    body.forEach((value) {
      _toppicks.add(
        Toppicks(
          id: value['id'],
          name: value['name'],
          price: value['price'],
          discountedPrice: value['discountedprice'],
          sku: value['sku'],
          photoPath1: value['photopath1'],
          categoryId: value['category_id'],
          status: value['status'],
          stock: value['stock'],
          flashSale: value['flashsale'],
          deleted: value['deleted'],
          description: value['description'],
          size: value['size'],
          color: value['color'],
          bandname: value['brand_name'],
        ),
      );
    });

    toppicks.value = _toppicks;
  }
}
