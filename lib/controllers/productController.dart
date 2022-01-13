import 'dart:convert';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductController extends GetxController {
  var product = <Product>[].obs;

  fetchproducts() async {
    var url = Uri.parse(
        "https://www.hamroelectronics.com.np/api/596810BITS/products");

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;

      final List<Product> _product = [];

      body.forEach((value) {
        _product.insert(
          0,
          Product(
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
              bandname: value['brand_name']),
        );
      });

      product.value = _product;
    } else {
      print(response.body);
    }
  }

  findProduct(int id) {
    return product.firstWhere((element) => element.id == id);
  }

  fetchCategoryProduct(int cid) {
    return product.where((p0) => p0.categoryId == cid).toList();
  }
}
