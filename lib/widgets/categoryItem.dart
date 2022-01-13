import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../controllers/productController.dart';

import '../screens/product_view_screen.dart';

class CategoryItem extends StatefulWidget {
  final int id;
  final String photopath1;
  final String name;
  final int price;
  final int? discountedPrice;
  final int userid;

  CategoryItem({
    required this.id,
    required this.photopath1,
    required this.name,
    required this.price,
    this.discountedPrice,
    required this.userid,
  });

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
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
          // width: mediaQuery.width * 0.9,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: mediaQuery.height * 0.28,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://hamroelectronics.com.np/images/product/${widget.photopath1}',
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: Image.asset('assets/logo/logo.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: mediaQuery.width * 0.02,
                        vertical: mediaQuery.height * 0.01),
                    child: Text(
                      widget.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: mediaQuery.width * 0.02,
                        bottom: mediaQuery.height * 0.01),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Rs ${widget.price}',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: widget.discountedPrice != null
                                ? mediaQuery.width * 0.03
                                : mediaQuery.width * 0.044,
                            color: widget.discountedPrice != null
                                ? Colors.grey[700]
                                : Colors.red[900],
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
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
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: mediaQuery.width * 0.044,
                                    color: Colors.red[900],
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
              // Positioned(
              //   top: 0,
              //   right: 0,
              //   child: IconButton(
              //     onPressed: () {
              //       setState(() {
              //         wishlistController.addToWishList(
              //             widget.userid, widget.id, context);
              //         if (isFav == true) {
              //           isFav = false;
              //           print(isFav);
              //         } else {
              //           isFav = true;
              //           print(isFav);
              //         }
              //       });
              //     },
              //     icon: Icon(
              //       isFav ? Icons.favorite : Icons.favorite_border,
              //       size: 24,
              //       color: isFav ? Colors.red : Colors.grey[700],
              //     ),
              //   ),
              // ),
              widget.discountedPrice == null
                  ? SizedBox()
                  : Positioned(
                      left: mediaQuery.width * 0.02,
                      child: Chip(
                        label: FittedBox(
                          fit: BoxFit.fill,
                          child: Text(
                            '$off% off',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
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
