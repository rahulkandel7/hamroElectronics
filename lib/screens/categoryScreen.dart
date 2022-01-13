import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/category_screen_items.dart';
import '../controllers/categoryController.dart';

class CategoryScreen extends StatelessWidget {
  final categoryController = Get.put(CategoryController());

  CategoryScreen({Key? key}) : super(key: key);

  Widget categoryItems(String title, String image, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 18.0,
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                'https://hamroelectronics.com.np/images/categories/$image'),
            maxRadius: 55,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: FittedBox(
              fit: BoxFit.fill,
              child: Text(title, style: Theme.of(context).textTheme.subtitle1),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 38.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (ctx, i) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  CategoryScreenItems.routeName,
                  arguments: categoryController.category[i].id,
                );
              },
              child: categoryItems(categoryController.category[i].name,
                  categoryController.category[i].image, context),
            );
          },
          itemCount: categoryController.category.length,
        ),
      ),
    );
  }
}
