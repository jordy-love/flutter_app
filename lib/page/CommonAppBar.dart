import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final String page;

  CommonAppBar(this.title, this.page);

  @override
  Widget build(BuildContext context) {
    List<Widget> rightList = _getRightWidget(page, context);
    return AppBar(
      title: Text(
        title,
      ),
      backgroundColor: Colors.cyan,
      centerTitle: true,
      //leading: , // left
      actions: rightList,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

List<Widget> _getRightWidget(page, context) {
  List<Widget> widgetArray = [];

  if (page.toString().compareTo("login") == 0) {
  } else {
    widgetArray.add(IconButton(
        icon: Icon(Icons.person),
        onPressed: () {
          Navigator.pushNamed(context, '/login');
        }));
  }

  return widgetArray;
}
