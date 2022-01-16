import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/productController.dart';
import '../controllers/wishlistController.dart';
import '../models/product.dart';
import '../screens/product_view_screen.dart';

class WishlistScreen extends StatefulWidget {
  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final wishlistController = Get.find<WishlistController>();

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
    super.initState();
    _getUserId();
    productController.fetchproducts();

    wishlistController.fetchWishlist(userid.toString()).then((_) {
      setState(() {});
    });
  }

  _onRefresh() async {
    await wishlistController.fetchWishlist(userid.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text(
          'My Wishlist',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: wishlistController.fetchWishlist(userid.toString()),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return RefreshIndicator(
              onRefresh: () => _onRefresh(),
              child: wishlistController.wishlist.isEmpty
                  ? Center(child: Image.asset('assets/Wishlist.png'))
                  : Padding(
                      padding: EdgeInsets.only(top: mediaQuery.height * 0.012),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 4.4 / 7,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 1,
                        ),
                        itemBuilder: (ctx, i) {
                          Product product = productController.findProduct(
                              wishlistController.wishlist[i].productid);
                          var wishlistItem = Padding(
                            padding: EdgeInsets.only(
                              right: mediaQuery.width * 0.02,
                              left: mediaQuery.width * 0.02,
                              bottom: mediaQuery.width * 0.01,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    ProductViewScreen.routeName,
                                    arguments: product.id);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).backgroundColor,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 5,
                                      color: Theme.of(context).shadowColor,
                                      offset: const Offset(5, 4),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: mediaQuery.width * 0.45,
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding:
                                              const EdgeInsets.only(top: 1.0),
                                          height: mediaQuery.height * 0.257,
                                          width: mediaQuery.width * 0.47,
                                          child: Center(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                'https://hamroelectronics.com.np/images/product/${product.photoPath1}',
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            product.name,
                                            maxLines: 2,
                                            overflow: TextOverflow.fade,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 18.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Rs ${product.price}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                    product.discountedPrice !=
                                                            null
                                                        ? Theme.of(context)
                                                            .textTheme
                                                            .caption
                                                        : Theme.of(context)
                                                            .textTheme
                                                            .headline6!
                                                            .copyWith(
                                                                color: Colors
                                                                    .red
                                                                    .shade800),
                                              ),
                                              product.discountedPrice != null
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 8.0,
                                                        right: 8.0,
                                                      ),
                                                      child: Text(
                                                        'Rs ${product.discountedPrice}',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Colors.red[900],
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        onPressed: () {
                                          wishlistController
                                              .addToWishList(
                                                  userid, product.id, context)
                                              .then((_) {
                                            _onRefresh();
                                          });
                                        },
                                        icon: Icon(
                                          Icons.favorite,
                                          size: 24,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                          return wishlistItem;
                        },
                        itemCount: wishlistController.wishlist.length,
                      ),
                    ),
            );
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 4.5 / 7,
                mainAxisSpacing: 5,
                crossAxisSpacing: 1,
              ),
              itemBuilder: (ctx, i) {
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      width: double.infinity,
                      height: mediaQuery.height * 0.25,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      width: mediaQuery.width * 0.4,
                      height: mediaQuery.height * 0.02,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                );
              },
              itemCount: 14,
            );
          }
        },
      ),
    );
  }
}
