import 'package:cartopia/utils/app-constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:cartopia/screens/user-panel/cart-screen.dart';
import 'package:flutter/services.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final String title;

  const AppBarWidget({
    Key? key,
    this.showBackButton = true,
    required this.title,
  }) : super(key: key);

  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();

  @override
  Size get preferredSize => const Size(0.0, 57.0);
}

class _AppBarWidgetState extends State<AppBarWidget> {
  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppConstant.appWhiteColor,
      leading: !widget.showBackButton
          ? null
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: GestureDetector(
                child: CircleAvatar(
                  backgroundColor:
                      AppConstant.appScendoryColor.withOpacity(0.1),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: AppConstant.appScendoryColor,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
      title: Text(
        widget.title == "Main Screen" ? _getGreeting() : widget.title,
        style: GoogleFonts.poppins(
          color: AppConstant.appScendoryColor,
        ),
      ),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
      widget.title == "Main Screen" || widget.title == "Product Details"
          ? GestureDetector(
              onTap: () => Get.to(() => const CartScreen()),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.shopping_cart,
                ),
              ),
            )
          : Container(),
    ];
  }
}
