import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/wishlist.dart';

class WishlistController extends GetxController {
  var wishlist = <Wishlist>[].obs;

  addToWishList(int userid, int productid, BuildContext context) async {
    final url =
        Uri.parse('https://hamroelectronics.com.np/api/596810BITS/wishlist');

    final jsons = {
      'userid': userid.toString(),
      'productid': productid.toString()
    };

    http.Response response = await http
        .post(url, body: jsons, headers: {'Accept': 'application/json'});

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
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.indigo,
        ),
      );
    } else {
      print('not sucess');
    }
  }

  fetchWishlist(String id) async {
    final url = Uri.parse(
        'https://hamroelectronics.com.np/api/596810BITS/wishlist/$id');

    final response =
        await http.get(url, headers: {'Accept': 'application/json'});

    final body = json.decode(response.body) as List;

    final _wishlist = <Wishlist>[];

    body.forEach((value) {
      _wishlist.insert(
        0,
        Wishlist(
          id: value["id"],
          productid: value["productid"],
          userid: value["userid"],
        ),
      );
    });

    wishlist.value = _wishlist;
  }
}
