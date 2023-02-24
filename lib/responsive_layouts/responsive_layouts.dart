import 'package:flutter/material.dart';
import 'package:instagram_c/provider/user_provider.dart';
import 'package:instagram_c/responsive_layouts/mobile_screen.dart';
import 'package:instagram_c/responsive_layouts/web_screen.dart';
import 'package:instagram_c/utils/global_variables.dart';
import 'package:provider/provider.dart';

class ResponsiveLayouts extends StatefulWidget {
  const ResponsiveLayouts({Key? key}) : super(key: key);

  @override
  State<ResponsiveLayouts> createState() => _ResponsiveLayoutsState();
}

class _ResponsiveLayoutsState extends State<ResponsiveLayouts> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context,
        listen: false); //listen false to listen only one time
    await _userProvider.refreshUser(); //function in user provider class
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < webScreenSize) {
          return MobileScreen();
        } else {
          return WebScreenLayout();
        }
      },
    );
  }
}
