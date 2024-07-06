import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

class HorizontalMenuCategoryItem extends StatelessWidget {
  const HorizontalMenuCategoryItem({
    Key? key,
    required this.title,
    required this.items,
  }) : super(key: key);

  final String title;
  final List items;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 0, left: 15),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontFamily: GoogleFonts.merriweather().fontFamily,
              color: Color.fromARGB(255, 37, 36, 36),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(left: 10, top: 15),
            child: Container(
              height: height * 0.32,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [...items],
              ),
            ))
      ],
    );
  }
}
