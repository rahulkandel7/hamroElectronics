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
                          childAspectRatio: 4.5 / 7,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 1,
                        ),
                        itemBuilder: (ctx, i) {
                          Product product = productController.findProduct(
                              wishlistController.wishlist[i].productid);
                          return Padding(
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
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 5,
                                      color: Colors.black12,
                                      offset: Offset(5, 4),
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
                                            style: TextStyle(
                                              fontSize: mediaQuery.width * 0.05,
                                              fontWeight: FontWeight.w500,
                                            ),
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
                                                style: TextStyle(
                                                  fontSize:
                                                      product.discountedPrice !=
                                                              null
                                                          ? mediaQuery.width *
                                                              0.04
                                                          : mediaQuery.width *
                                                              0.05,
                                                  color:
                                                      product.discountedPrice !=
                                                              null
                                                          ? Colors.grey[700]
                                                          : Colors.red[900],
                                                  fontWeight: FontWeight.w500,
                                                  decoration:
                                                      product.discountedPrice !=
                                                              null
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : TextDecoration.none,
                                                ),
                                              ),
                                              product.discountedPrice != null
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              right: 8.0),
                                                      child: Text(
                                                        'Rs ${product.discountedPrice}',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize:
                                                              mediaQuery.width *
                                                                  0.05,
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
                        },
                        itemCount: wishlistController.wishlist.length,
                      ),
                    ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 1.0,
              ),
            );
          }
        },
      ),
    );
  }
}
