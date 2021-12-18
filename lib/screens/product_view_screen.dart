import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/productController.dart';
import '../models/product.dart';
import '../controllers/wishlistController.dart';
import '../controllers/cartController.dart';
import '../models/cart.dart';

class ProductViewScreen extends StatefulWidget {
  static const routeName = '/product-view';

  @override
  State<ProductViewScreen> createState() => _ProductViewScreenState();
}

class _ProductViewScreenState extends State<ProductViewScreen> {
  final productController = Get.put(ProductController());
  final wishlistController = Get.put(WishlistController());
  final cartController = Get.put(CartController());

  int off = 0;

  int userid = 0;

  String? color;
  String size = "";

  _getUserId() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var userInfo = _prefs.getString('user');
    var userDecoded = json.decode(userInfo!) as Map<String, dynamic>;
    setState(() {
      userid = userDecoded["id"] as int;
    });
  }

  bool isFav = false;
  bool onCart = false;

  findPercent() {
    int productId = ModalRoute.of(context)?.settings.arguments as int;
    Product product = productController.findProduct(productId);

    if (product.discountedPrice != null) {
      double div = product.price / 100;
      double percent = (product.discountedPrice! - product.price) / div;
      off = percent.abs().round();
    }
  }

  iswishlist() {
    int l = wishlistController.wishlist.length;
    int productId = ModalRoute.of(context)!.settings.arguments as int;

    for (var i = 0; i < l; i++) {
      if (wishlistController.wishlist[i].productid == productId) {
        setState(() {
          isFav = true;
        });
      }
    }
  }

  isCart() {
    int l = cartController.carts.length;
    int productId = ModalRoute.of(context)!.settings.arguments as int;

    for (var i = 0; i < l; i++) {
      if (cartController.carts[i].productid == productId) {
        setState(() {
          onCart = true;
        });
      }
    }
  }

  int quantity = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserId();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    findPercent();
    iswishlist();
    isCart();
  }

  bool selected = false;

  @override
  Widget build(BuildContext context) {
    int productId = ModalRoute.of(context)!.settings.arguments as int;
    Product product = productController.findProduct(productId);

    var mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: mediaQuery.height * 0.85,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: mediaQuery.width * 0.03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              wishlistController
                                  .fetchWishlist(userid.toString());
                              cartController.fetchCart(userid.toString());
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                            ),
                          ),
                          SizedBox(
                            height: mediaQuery.height * 0.07,
                            child: Image.asset(
                              'assets/logo/logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      wishlistController.addToWishList(
                                          userid, productId, context);
                                      if (isFav == true) {
                                        isFav = false;
                                      } else {
                                        isFav = true;
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    isFav
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFav ? Colors.red : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      child: Center(
                        child: Chip(
                          label: Text(
                            '$off% OFF',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          backgroundColor: Colors.indigo,
                        ),
                      ),
                      visible: off != 0 ? true : false,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: mediaQuery.height * 0.01),
                      child: SizedBox(
                        height: mediaQuery.height * 0.35,
                        width: double.infinity,
                        child: GestureDetector(
                          child: InteractiveViewer(
                            panEnabled: true,
                            scaleEnabled: true,
                            minScale: 1,
                            maxScale: 4,
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://hamroelectronics.com.np/images/product/${product.photoPath1}',
                              fit: BoxFit.scaleDown,
                              placeholder: (context, url) => Center(
                                child: Image.asset('assets/logo/logo.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: mediaQuery.width * 0.86,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: mediaQuery.height * 0.02,
                                horizontal: mediaQuery.width * 0.06),
                            child: Text(
                              product.name,
                              maxLines: 3,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          child: IconButton(
                            onPressed: () {
                              Share.share(
                                "https://hamroelectronics.com.np/viewproduct/${product.sku}",
                              );
                            },
                            icon: const Icon(
                              Icons.share,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: mediaQuery.height * 0.01,
                            bottom: mediaQuery.height * 0.01,
                            left: mediaQuery.width * 0.06,
                            right: mediaQuery.width * 0.03,
                          ),
                          child: const Text(
                            'Brand:',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: mediaQuery.height * 0.01,
                          ),
                          child: Text(
                            product.bandname,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: mediaQuery.height * 0.01,
                            bottom: mediaQuery.height * 0.01,
                            left: mediaQuery.width * 0.06,
                            right: mediaQuery.width * 0.03,
                          ),
                          child: const Text(
                            'Size:',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: mediaQuery.height * 0.01,
                          ),
                          child: product.size == null
                              ? const Text(
                                  'No Size Available',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                  ),
                                )
                              : Row(
                                  children: product.size!
                                      .split(",")
                                      .toList()
                                      .map((e) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: mediaQuery.height * 0.02,
                                        horizontal: mediaQuery.width * 0.01,
                                      ),
                                      child: ChoiceChip(
                                        backgroundColor: Colors.indigo.shade100,
                                        labelStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        selected: size.contains(e),
                                        onSelected: (value) {
                                          setState(() {
                                            size = e;

                                            print(size);
                                          });
                                        },
                                        tooltip: e,
                                        selectedShadowColor:
                                            Colors.indigo.shade300,
                                        selectedColor: Colors.indigo,
                                        label: Text(e),
                                      ),
                                    );
                                  }).toList(),
                                ),
                          // DropdownButton(
                          //     value: size,
                          //     hint: const Text('Choose Size'),
                          //     items: product.size!
                          //         .split(",")
                          //         .toList()
                          //         .map((e) {
                          //       return DropdownMenuItem<String>(
                          //         value: e,
                          //         child: Text(e),
                          //       );
                          //     }).toList(),
                          //     onChanged: (s) {
                          //       setState(() {
                          //         size = s.toString();
                          //       });
                          //     },
                          //   ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: mediaQuery.height * 0.01,
                            bottom: mediaQuery.height * 0.01,
                            left: mediaQuery.width * 0.06,
                            right: mediaQuery.width * 0.03,
                          ),
                          child: const Text(
                            'Color:',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: mediaQuery.height * 0.01,
                          ),
                          child: product.color == null
                              ? const Text(
                                  'No Color Available',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                  ),
                                )
                              : DropdownButton(
                                  value: color,
                                  hint: const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text('Choose Color'),
                                  ),
                                  items: product.color!
                                      .split(",")
                                      .toList()
                                      .map((e) {
                                    return DropdownMenuItem<String>(
                                      value: e,
                                      child: Text(e),
                                    );
                                  }).toList(),
                                  onChanged: (c) {
                                    setState(() {
                                      color = c.toString();
                                    });
                                  },
                                ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: mediaQuery.height * 0.01,
                            bottom: mediaQuery.height * 0.01,
                            left: mediaQuery.width * 0.06,
                            right: mediaQuery.width * 0.03,
                          ),
                          child: const Text(
                            'Quantity',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: mediaQuery.height * 0.01,
                          ),
                          child: SizedBox(
                            // width: mediaQuery.width * 0.4,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (quantity < 2) {
                                      return;
                                    } else {
                                      setState(() {
                                        quantity--;
                                      });
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.minimize_outlined,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(
                                    mediaQuery.width * 0.02,
                                  ),
                                  decoration: const BoxDecoration(boxShadow: [
                                    BoxShadow(
                                      blurRadius: 5.0,
                                      color: Colors.black12,
                                    ),
                                  ], color: Colors.white),
                                  width: mediaQuery.width * 0.2,
                                  child: Center(
                                    child: Text(
                                      quantity.toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (quantity < product.stock) {
                                      setState(() {
                                        quantity++;
                                      });
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: mediaQuery.height * 0.01,
                            bottom: mediaQuery.height * 0.01,
                            left: mediaQuery.width * 0.06,
                            right: mediaQuery.width * 0.03,
                          ),
                          child: const Text(
                            'Stock:',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: mediaQuery.height * 0.01,
                          ),
                          child: Text(
                            product.stock == 0
                                ? 'Out of Stock'
                                : product.stock.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: mediaQuery.height * 0.01,
                          horizontal: mediaQuery.width * 0.06),
                      child: const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: mediaQuery.height * 0.01,
                          horizontal: mediaQuery.width * 0.06),
                      child: Text(
                        product.description ?? 'No Description',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: mediaQuery.height * 0.08,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                boxShadow: [
                  const BoxShadow(
                    blurRadius: 4.0,
                    color: Colors.black12,
                  )
                ],
              ),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: mediaQuery.width * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    product.discountedPrice == null
                        ? Text(
                            'Rs ${product.price}',
                            style: TextStyle(
                              fontSize: mediaQuery.width * 0.05,
                              color: Colors.red[800],
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Rs ${product.price}',
                                style: TextStyle(
                                  fontSize: mediaQuery.width * 0.05,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Rs ${product.discountedPrice}',
                                  style: TextStyle(
                                    fontSize: mediaQuery.width * 0.06,
                                    color: Colors.red[800],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                    product.stock != 0
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              var _cart = Cart(
                                userid: userid,
                                productid: productId,
                                quantity: quantity,
                                size: size,
                                color: color,
                              );
                              cartController.addToCart(_cart, context);
                              cartController.fetchCart(userid.toString());
                            },
                            child: Row(
                              children: [
                                Text(
                                  onCart ? 'Update Cart' : 'Add To Cart',
                                  style: TextStyle(
                                    fontSize: mediaQuery.width * 0.05,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: mediaQuery.width * 0.02),
                                  child: Icon(
                                    Icons.shopping_cart,
                                    size: mediaQuery.width * 0.05,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
