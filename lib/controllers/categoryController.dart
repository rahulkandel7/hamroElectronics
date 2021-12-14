import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/category.dart';

class CategoryController extends GetxController {
  var category = <Category>[].obs;

  fetchCtaegory() async {
    final url = Uri.parse("https://hamroelectronics.com.np/api/category");

    final response =
        await http.get(url, headers: {'Accept': 'application/json'});

    final body = json.decode(response.body) as List;

    final List<Category> _category = [];
    print(body);

    body.forEach((element) {
      _category.add(
        Category(
          id: element['id'],
          name: element['category_name'],
          image: element['photopath'],
        ),
      );
    });

    category.value = _category;
  }

  findCategory(int id) {
    return category.firstWhere((element) => element.id == id);
  }
}
