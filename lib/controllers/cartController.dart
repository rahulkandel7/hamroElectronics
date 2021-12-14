import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/cart.dart';

class CartController extends GetxController {
  var carts = <Cart>[].obs;

  var total = 0.obs;

  var tc = 0.obs;

  static var client = http.Client();

  addToCart(Cart cart, BuildContext context) async {
    final url = Uri.parse('https://hamroelectronics.com.np/api/cart');

    final jsons = {
      "userid": cart.userid.toString(),
      "productid": cart.productid.toString(),
      "quantity": cart.quantity.toString(),
      "color": cart.color.toString(),
      "size": cart.size.toString(),
    };

    final response = await client.post(
      url,
      headers: {'Accept': 'application/json'},
      body: jsons,
    );

    if (response.statusCode == 200) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.body,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          elevation: 5.0,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.indigo,
        ),
      );
    } else {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          elevation: 5.0,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.indigo,
        ),
      );
    }
  }

  fetchCart(String id) async {
    final url = Uri.parse('https://hamroelectronics.com.np/api/cart/$id');

    final response =
        await client.get(url, headers: {'Accept': 'application/json'});

    final _carts = <Cart>[];

    // final body = json.decode(response.body) as List;
    List body = json.decode(response.body);

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

    // body.forEach((key, value) {
    //   _carts.insert(
    //     0,
    //     Cart(
    //       userid: value["userid"],
    //       productid: value["productid"],
    //       quantity: value["quantity"],
    //       id: value["id"],
    //       size: value["size"],
    //       color: value["color"],
    //     ),
    //   );
    // });

    carts.value = _carts;
    tc.value = _carts.length;
  }

  deleteCart(int? id, BuildContext context) async {
    final url =
        Uri.parse('https://hamroelectronics.com.np/api/cart/delete/$id');

    final response =
        await client.delete(url, headers: {'Accept': 'application/json'});

    print(response.body);

    if (response.statusCode == 200) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.body,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          elevation: 5.0,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.indigo,
        ),
      );
    } else {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          elevation: 5.0,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.indigo,
        ),
      );
    }
  }
}
