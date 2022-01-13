import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cartController.dart';
import '../screens/product_view_screen.dart';

class CartItems extends StatefulWidget {
  final int? id;
  final int pid;
  final String image;
  final String name;
  int quantity;
  final int price;
  final int stock;
  final int? discountedPrice;
  final int userid;

  CartItems({
    required this.id,
    required this.pid,
    required this.image,
    required this.name,
    required this.quantity,
    required this.price,
    required this.stock,
    this.discountedPrice,
    required this.userid,
  });

  @override
  State<CartItems> createState() => _CartItemsState();
}

class _CartItemsState extends State<CartItems> {
  final cartController = Get.put(CartController());
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductViewScreen.routeName, arguments: widget.pid);
        },
        child: Dismissible(
          key: UniqueKey(),
          background: Container(
            alignment: AlignmentDirectional.centerEnd,
            padding: EdgeInsets.only(right: mediaQuery.width * 0.05),
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
            cartController.deleteCart(widget.id, context);
            // .then((_) {
            //   Navigator.of(context).pushReplacementNamed(CartScreen.routeName);
            // });
          },
          behavior: HitTestBehavior.translucent,
          direction: DismissDirection.endToStart,
          dragStartBehavior: DragStartBehavior.down,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
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
                  width: mediaQuery.height * 0.1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                    child: Image.network(
                      'https://hamroelectronics.com.np/images/product/${widget.image}',
                    ),
                  ),
                ),
                SizedBox(
                  width: mediaQuery.width * 0.6,
                  child: Padding(
                    padding: EdgeInsets.only(left: mediaQuery.width * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: mediaQuery.height * 0.01),
                          child: Row(
                            children: [
                              widget.discountedPrice == null
                                  ? Text(
                                      'Rs ${widget.price}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.red[800],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Rs ${widget.price}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: mediaQuery.width * 0.01),
                                          child: Text(
                                            'Rs ${widget.discountedPrice}',
                                            style: TextStyle(
                                              fontSize: 18,
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
                          padding:
                              EdgeInsets.only(top: mediaQuery.height * 0.01),
                          child: Row(
                            children: [
                              widget.discountedPrice == null
                                  ? Text(
                                      'Sub-Total Rs ${widget.price * widget.quantity}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.red[800],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: mediaQuery.width * 0.01),
                                          child: Text(
                                            'Sub-Total: Rs ${widget.discountedPrice! * widget.quantity}',
                                            style: TextStyle(
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
                    IconButton(
                      onPressed: () {
                        if (widget.quantity < widget.stock) {
                          setState(() {
                            widget.quantity++;
                          });
                        }
                      },
                      icon: Icon(
                        Icons.add,
                      ),
                    ),
                    Text('${widget.quantity}'),
                    IconButton(
                      onPressed: () {
                        if (widget.quantity != 1) {
                          setState(() {
                            widget.quantity--;
                          });
                        }
                      },
                      icon: Icon(
                        Icons.minimize,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
