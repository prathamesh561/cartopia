// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeadingWidget extends StatelessWidget {
  final String headingTitle;
  final String headingSubTitle;
  final VoidCallback onTap;
  const HeadingWidget({
    super.key,
    required this.headingTitle,
    required this.headingSubTitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headingTitle,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                Text(
                  headingSubTitle,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            IconButton(
                onPressed: onTap,
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                )),
          ],
        ),
      ),
    );
  }
}
