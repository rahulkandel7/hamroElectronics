import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamro_electronics/widgets/categoryItem.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/categoryController.dart';
import '../controllers/productController.dart';
import '../models/category.dart';
import '../widgets/homeproduct.dart';

class CategoryScreenItems extends StatefulWidget {
  static const routeName = '/cat-items';

  @override
  State<CategoryScreenItems> createState() => _CategoryScreenItemsState();
}

class _CategoryScreenItemsState extends State<CategoryScreenItems> {
  final categoryController = Get.put(CategoryController());
  final productController = Get.put(ProductController());

  int userid = 0;

  _getUserId() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    var userInfo = _prefs.getString('user');

    var userDecoded = json.decode(userInfo!) as Map<String, dynamic>;

    setState(() {
      userid = userDecoded["id"] as int;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserId();
  }

  @override
  Widget build(BuildContext context) {
    int cid = ModalRoute.of(context)!.settings.arguments as int;
    Category category = categoryController.findCategory(cid);
    var product = productController.fetchCategoryProduct(cid);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          category.name,
          style: TextStyle(
            fontSize: 29,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 5,
            mainAxisSpacing: 15,
            crossAxisSpacing: 1,
          ),
          itemCount: product.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.01),
              child: CategoryItem(
                userid: userid,
                id: product[i].id,
                name: product[i].name,
                price: product[i].price,
                discountedPrice: product[i].discountedPrice,
                photopath1: product[i].photoPath1,
              ),
            );
          }),
    );
  }
}
