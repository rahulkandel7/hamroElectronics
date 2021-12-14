import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/productController.dart';
import '../controllers/wishlistController.dart';
import '../screens/product_view_screen.dart';

class Toppicks extends StatefulWidget {
  final int id;
  final String photopath1;
  final String name;
  final int price;
  final int? discountedPrice;
  final int userid;

  Toppicks({
    required this.id,
    required this.photopath1,
    required this.name,
    required this.price,
    this.discountedPrice,
    required this.userid,
  });
  @override
  State<Toppicks> createState() => _ToppicksState();
}

class _ToppicksState extends State<Toppicks> {
  final wishlistController = Get.put(WishlistController());

  final productController = Get.put(ProductController());

  int off = 0;

  findPercent() {
    if (widget.discountedPrice != null) {
      double div = widget.price / 100;
      double percent = (widget.discountedPrice! - widget.price) / div;
      off = percent.abs().round();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findPercent();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
        right: mediaQuery.width * 0.02,
        left: mediaQuery.width * 0.02,
        bottom: mediaQuery.width * 0.01,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductViewScreen.routeName, arguments: widget.id);
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 1.0),
                    height: mediaQuery.height * 0.257,
                    width: mediaQuery.width * 0.47,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          'https://hamroelectronics.com.np/images/product/${widget.photopath1}',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      widget.name,
                      maxLines: 2,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Row(
                      children: [
                        Text(
                          'Rs ${widget.price}',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: widget.discountedPrice != null ? 14 : 17,
                            color: widget.discountedPrice != null
                                ? Colors.grey[700]
                                : Colors.red[900],
                            fontWeight: FontWeight.w500,
                            decoration: widget.discountedPrice != null
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        widget.discountedPrice != null
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Text(
                                  'Rs ${widget.discountedPrice}',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.red[900],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
              widget.discountedPrice == null
                  ? SizedBox()
                  : Positioned(
                      left: 7,
                      child: Chip(
                        label: Text(
                          '$off% off',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.indigo,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
