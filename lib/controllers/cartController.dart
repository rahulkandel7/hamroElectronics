import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart.dart';

class CartController extends GetxController {
  var carts = <Cart>[].obs;

  var total = 0.obs;

  String tokens = "";

  var tc = 0.obs;

  var length = 0.obs;

  addToCart(Cart cart, BuildContext context) async {
    final url =
        Uri.parse('https://hamroelectronics.com.np/api/596810BITS/cart');

    final jsons = {
      "userid": cart.userid.toString(),
      "productid": cart.productid.toString(),
      "quantity": cart.quantity.toString(),
      "color": cart.color.toString(),
      "size": cart.size.toString(),
    };

    final response = await http.post(
      url,
      headers: {'Accept': 'application/json'},
      body: jsons,
    );

    if (response.statusCode == 200) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.body,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          elevation: 5.0,
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.indigo,
        ),
      );
    } else {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          elevation: 5.0,
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.indigo,
        ),
      );
    }
  }

  fetchCart(String id) async {
    final url =
        Uri.parse('https://hamroelectronics.com.np/api/596810BITS/cart/$id');

    final response =
        await http.get(url, headers: {'Accept': 'application/json'});

    final _carts = <Cart>[];
    if (response.statusCode == 200) {
      List body = json.decode(response.body);

      print(body);

      body.forEach((el) {
        _carts.insert(
          0,
          Cart(
            id: el["id"],
            userid: el["userid"],
            productid: el["productid"],
            quantity: el["quantity"],
            size: el["size"],
            color: el["color"],
          ),
        );
      });

      carts.value = _carts;
      length.value = _carts.length;

      print('I am cart');
      print(length.value);
    } else {
      print('I am Error');

      print(response.body);

      print('I am Error');
    }
  }

  deleteCart(int? id, BuildContext context) async {
    final url = Uri.parse(
        'https://hamroelectronics.com.np/api/596810BITS/cart/delete/$id');

    final response =
        await http.delete(url, headers: {'Accept': 'application/json'});

    print(response.body);

    if (response.statusCode == 200) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.body,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          elevation: 5.0,
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.indigo,
        ),
      );
    } else {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          elevation: 5.0,
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.indigo,
        ),
      );
    }
  }
}
