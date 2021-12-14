import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  Color color;
  IconData icon;
  String title;

  CategoryWidget({
    required this.color,
    required this.icon,
    required this.title,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  10,
                ),
                color: color,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    color: Colors.black26,
                    offset: Offset(2, 3),
                  )
                ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
