import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/areaController.dart';
import '../controllers/cartController.dart';
import '../controllers/productController.dart';
import '../models/product.dart';
import '../screens/checkout_screen.dart';

import '../screens/product_view_screen.dart';

class CartScreen extends StatefulWidget {
  static const routeName = "/cart";
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final cartController = Get.find<CartController>();
  final productController = Get.put(ProductController());
  final areaController = Get.put(AreaController());

  int userId = 0;

  int totalPrice = 0;

  bool showPrice = false;

  _getUserID() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    var userInfo = _prefs.getString('user');

    var userDecoded = json.decode(userInfo!) as Map<String, dynamic>;

    setState(() {
      userId = userDecoded["id"] as int;
    });
  }

  _onRefresh() async {
    await cartController.fetchCart(userId.toString()).then((_) {
      setState(() {
        showPrice = true;
        cartController.total.value = 0;
        for (var element in cartController.carts) {
          Product product = productController.findProduct(element.productid);
          if (product.discountedPrice != null) {
            cartController.total.value = cartController.total.value +
                (product.discountedPrice!.toInt() * element.quantity);
          } else {
            cartController.total.value =
                cartController.total.value + (product.price * element.quantity);
          }
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserID();
    print('this is init');
    cartController.fetchCart(userId.toString()).then((_) {
      cartController.total.value = 0;
      for (var element in cartController.carts) {
        Product product = productController.findProduct(element.productid);
        if (product.discountedPrice != null) {
          cartController.total.value = cartController.total.value +
              (product.discountedPrice!.toInt() * element.quantity);
          print('dis');
        } else {
          cartController.total.value =
              cartController.total.value + (product.price * element.quantity);
        }
      }
    });
    areaController.fetchArea();
  }

  @override
  void dispose() {
    super.dispose();
    cartController.total.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: cartController.fetchCart(userId.toString()),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return RefreshIndicator(
              onRefresh: () => _onRefresh(),
              child: cartController.carts.isEmpty
                  ? Center(
                      child: Image.asset('assets/CartEmpty.png'),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: mediaQuery.height * 0.7,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: mediaQuery.height * 0.01),
                                child: Text(
                                  'Swipe left to Delete',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.red.shade300,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: mediaQuery.height * 0.66,
                                child: ListView.builder(
                                  itemCount: cartController.carts.length,
                                  itemBuilder: (context, index) {
                                    Product product = productController
                                        .findProduct(cartController
                                            .carts[index].productid);

                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              ProductViewScreen.routeName,
                                              arguments: product.id);
                                        },
                                        child: Dismissible(
                                          key: UniqueKey(),
                                          background: Container(
                                            alignment:
                                                AlignmentDirectional.centerEnd,
                                            padding: EdgeInsets.only(
                                                right: mediaQuery.width * 0.05),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.red,
                                            ),
                                            child: const Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                          ),
                                          onDismissed: (direction) {
                                            cartController.deleteCart(
                                                cartController.carts[index].id,
                                                context);

                                            _onRefresh().then((_) {
                                              setState(() {
                                                showPrice = false;
                                                print(showPrice);
                                              });
                                            });
                                          },
                                          behavior: HitTestBehavior.translucent,
                                          direction:
                                              DismissDirection.endToStart,
                                          dragStartBehavior:
                                              DragStartBehavior.down,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 4),
                                                  color: Colors.grey.shade300,
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width:
                                                      mediaQuery.height * 0.1,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      10,
                                                    ),
                                                    child: FadeInImage.assetNetwork(
                                                        placeholder:
                                                            'assets/logo/logo.png',
                                                        image:
                                                            'https://hamroelectronics.com.np/images/product/${product.photoPath1}'),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: mediaQuery.width * 0.6,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: mediaQuery.width *
                                                            0.05),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          product.name,
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                          ),
                                                          maxLines: 2,
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              top: mediaQuery
                                                                      .height *
                                                                  0.01),
                                                          child: Row(
                                                            children: [
                                                              product.discountedPrice ==
                                                                      null
                                                                  ? Text(
                                                                      'Rs ${product.price}',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Colors
                                                                            .red[800],
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    )
                                                                  : Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Text(
                                                                          'Rs ${product.price}',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            decoration:
                                                                                TextDecoration.lineThrough,
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.only(left: mediaQuery.width * 0.01),
                                                                          child:
                                                                              Text(
                                                                            'Rs ${product.discountedPrice}',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 16,
                                                                              color: Colors.red[800],
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              top: mediaQuery
                                                                      .height *
                                                                  0.01),
                                                          child: Row(
                                                            children: [
                                                              product.discountedPrice ==
                                                                      null
                                                                  ? Text(
                                                                      'Sub-Total Rs ${product.price * cartController.carts[index].quantity}',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Colors
                                                                            .red[800],
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    )
                                                                  : Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.only(left: mediaQuery.width * 0.01),
                                                                          child:
                                                                              Text(
                                                                            'Sub-Total: Rs ${product.discountedPrice! * cartController.carts[index].quantity}',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 16,
                                                                              color: Colors.red[800],
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    // IconButton(
                                                    //   onPressed: () {
                                                    //     if (cartController
                                                    //             .carts[index].quantity <
                                                    //         product.stock) {
                                                    //       setState(() {
                                                    //         quantity++;
                                                    //       });
                                                    //     }
                                                    //   },
                                                    //   icon: Icon(
                                                    //     Icons.add,
                                                    //   ),
                                                    // ),
                                                    Text(
                                                        'Qty: ${cartController.carts[index].quantity}'),
                                                    // IconButton(
                                                    //   onPressed: () {
                                                    //     if (quantity != 1) {
                                                    //       setState(() {
                                                    //         quantity--;
                                                    //       });
                                                    //     }
                                                    //   },
                                                    //   icon: Icon(
                                                    //     Icons.minimize,
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: mediaQuery.height * 0.18,
                          alignment: Alignment.topCenter,
                          padding:
                              EdgeInsets.only(top: mediaQuery.height * 0.01),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 3,
                                  offset: const Offset(0, -3),
                                  color: Colors.grey.shade300,
                                ),
                              ]),
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 15,
                              right: 15,
                              bottom: 40,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Total:',
                                      style: TextStyle(
                                        fontSize: mediaQuery.width * 0.05,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    showPrice
                                        ? Obx(() {
                                            return Text(
                                              ' Rs ${cartController.total.value}',
                                              style: TextStyle(
                                                fontSize:
                                                    mediaQuery.width * 0.06,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            );
                                          })
                                        : const Text(
                                            ' Rs XXXX',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                  ],
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.indigo,
                                    elevation: 0,
                                    enableFeedback: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        30,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(CheckOutScreen.routeName);
                                    setState(() {
                                      cartController.total.value = 0;
                                      for (var element
                                          in cartController.carts) {
                                        Product product = productController
                                            .findProduct(element.productid);
                                        if (product.discountedPrice != null) {
                                          cartController.total.value =
                                              cartController.total.value +
                                                  (product.discountedPrice!
                                                          .toInt() *
                                                      element.quantity);
                                          print('dis');
                                        } else {
                                          cartController.total.value =
                                              cartController.total.value +
                                                  (product.price *
                                                      element.quantity);
                                        }
                                      }
                                      cartController.tc.value =
                                          cartController.total.value;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        'CheckOut',
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
