// lib/views/cart_page.dart
import 'package:flutter/material.dart';
import 'package:nour_market2/views/categories_page.dart';

import '../widgets/buildBannerNew.dart';

class CartPage extends StatelessWidget {
  CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBarNew(title: 'السلة'),
    );


  }
}
