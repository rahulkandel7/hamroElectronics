import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SlideShowItem extends StatelessWidget {
  final String url;

  SlideShowItem({required this.url});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 5.0,
        right: 5.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedNetworkImage(
            imageUrl:
                'https://hamroelectronics.com.np/images/banner/mobile/$url',
            placeholder: (context, url) => Center(
              child: Image.asset('assets/logo/logo.png'),
            ),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
