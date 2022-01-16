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
  final cartController = Get.put(CartController());
  final productController = Get.put(ProductController());
  final areaController = Get.put(AreaController());

  int userId = 0;

  int totalPrice = 0;

  bool showPrice = true;

  _getUserID() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    var userInfo = _prefs.getString('user');

    var userDecoded = json.decode(userInfo!) as Map<String, dynamic>;

    setState(() {
      userId = userDecoded["id"] as int;
    });
  }

  Future<void> _onRefresh() async {
    await cartController.fetchCart(userId.toString());
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getUserID();
    areaController.fetchArea();
    cartController.fetchCart(userId.toString()).then((_) {
      setState(() {});
    });

    print('Me cart created');
  }

  @override
  void dispose() {
    super.dispose();
    cartController.total.value = 0;
    print('Cart disposed');
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: cartController.fetchCart(userId.toString()),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var cartList = Expanded(
              // height: mediaQuery.height * 0.83,
              child: ListView.builder(
                itemCount: cartController.carts.length,
                itemBuilder: (context, index) {
                  Product product = productController
                      .findProduct(cartController.carts[index].productid);

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
                          alignment: AlignmentDirectional.centerEnd,
                          padding:
                              EdgeInsets.only(right: mediaQuery.width * 0.05),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red,
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        onDismissed: (direction) {
                          cartController
                              .deleteCart(
                                  cartController.carts[index].id, context)
                              .then((_) {
                            setState(() {});
                          });
                        },
                        behavior: HitTestBehavior.translucent,
                        direction: DismissDirection.endToStart,
                        dragStartBehavior: DragStartBehavior.down,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4,
                                offset: const Offset(0, 4),
                                color: Theme.of(context).shadowColor,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: mediaQuery.height * 0.1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                  child: FadeInImage.assetNetwork(
                                      placeholder: 'assets/logo/logo.png',
                                      image:
                                          'https://hamroelectronics.com.np/images/product/${product.photoPath1}'),
                                ),
                              ),
                              SizedBox(
                                width: mediaQuery.width * 0.6,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: mediaQuery.width * 0.05),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                        maxLines: 2,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: mediaQuery.height * 0.01),
                                        child: Row(
                                          children: [
                                            product.discountedPrice == null
                                                ? Text(
                                                    'Rs ${product.price}',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.red[800],
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  )
                                                : Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Rs ${product.price}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: mediaQuery
                                                                        .width *
                                                                    0.01),
                                                        child: Text(
                                                          'Rs ${product.discountedPrice}',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color:
                                                                Colors.red[800],
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                'Poppins',
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
                                            top: mediaQuery.height * 0.01),
                                        child: Row(
                                          children: [
                                            product.discountedPrice == null
                                                ? Text(
                                                    'Sub-Total Rs ${product.price * cartController.carts[index].quantity}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.red[800],
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  )
                                                : Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: mediaQuery
                                                                        .width *
                                                                    0.01),
                                                        child: Text(
                                                          'Sub-Total: Rs ${product.discountedPrice! * cartController.carts[index].quantity}',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.red[800],
                                                            fontFamily:
                                                                'Poppins',
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                  Text(
                                    'Qty: ${cartController.carts[index].quantity}',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
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
            );
            return RefreshIndicator(
              onRefresh: () => _onRefresh(),
              child: cartController.carts.isEmpty
                  ? Center(
                      child: Image.asset('assets/CartEmpty.png'),
                    )
                  : Stack(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          // height: mediaQuery.height * 0.7,
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
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              cartList,
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: mediaQuery.height * 0.08,
                          right: mediaQuery.width * 0.03,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  30,
                                ),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                cartController.total.value = 0;
                                for (var element in cartController.carts) {
                                  Product product = productController
                                      .findProduct(element.productid);
                                  if (product.discountedPrice != null) {
                                    cartController.total.value =
                                        cartController.total.value +
                                            (product.discountedPrice!.toInt() *
                                                element.quantity);
                                  } else {
                                    cartController.total.value =
                                        cartController.total.value +
                                            (product.price * element.quantity);
                                  }
                                }
                              });
                              cartController.tc.value =
                                  cartController.total.value;
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      CheckOutScreen(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.linear;

                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));

                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: mediaQuery.width * 0.02),
                                  child: const Text(
                                    'Checkout',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Container(
                        //   // height: mediaQuery.height * 0.12,
                        //   alignment: Alignment.centerRight,
                        //   margin: EdgeInsets.only(
                        //     bottom: mediaQuery.height * 0.06,
                        //     right: mediaQuery.width * 0.04,
                        //   ),
                        //   width: double.infinity,
                        //   child:
                        //   Positioned(
                        //     bottom: mediaQuery.height * 0.03,
                        //     child: Container(
                        //       decoration: BoxDecoration(
                        //         shape: BoxShape.circle,
                        //         color: Colors.indigo,
                        //       ),
                        //       child: IconButton(
                        //         onPressed: () {
                        //           Navigator.of(context).push(
                        //             PageRouteBuilder(
                        //               pageBuilder: (context, animation,
                        //                       secondaryAnimation) =>
                        //                   CheckOutScreen(),
                        //               transitionsBuilder: (context, animation,
                        //                   secondaryAnimation, child) {
                        //                 const begin = Offset(1.0, 0.0);
                        //                 const end = Offset.zero;
                        //                 const curve = Curves.linear;

                        //                 var tween = Tween(
                        //                         begin: begin, end: end)
                        //                     .chain(CurveTween(curve: curve));

                        //                 return SlideTransition(
                        //                   position: animation.drive(tween),
                        //                   child: child,
                        //                 );
                        //               },
                        //             ),
                        //           );
                        //           setState(() {
                        //             cartController.total.value = 0;
                        //             for (var element in cartController.carts) {
                        //               Product product = productController
                        //                   .findProduct(element.productid);
                        //               if (product.discountedPrice != null) {
                        //                 cartController.total.value =
                        //                     cartController.total.value +
                        //                         (product.discountedPrice!
                        //                                 .toInt() *
                        //                             element.quantity);
                        //                 print('dis');
                        //               } else {
                        //                 cartController.total.value =
                        //                     cartController.total.value +
                        //                         (product.price *
                        //                             element.quantity);
                        //               }
                        //             }
                        //             cartController.tc.value =
                        //                 cartController.total.value;
                        //           });
                        //         },
                        //         icon: Icon(
                        //           Icons.arrow_forward,
                        //           color: Colors.white,
                        //         ),
                        //       ),
                        //     ),
                        //   ),

                        // ),
                      ],
                    ),
            );
          } else {
            return SizedBox(
              height: mediaQuery.height * 9,
              child: ListView.builder(
                itemBuilder: (ctx, i) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          width: mediaQuery.width * 0.3,
                          height: mediaQuery.height * 0.1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                            color: Colors.grey.shade300,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              width: mediaQuery.width * 0.6,
                              height: mediaQuery.height * 0.03,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                                color: Colors.grey.shade300,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10, top: 5),
                              width: mediaQuery.width * 0.4,
                              height: mediaQuery.height * 0.03,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
                itemCount: 8,
              ),
            );
          }
        },
      ),
    );
  }
}
