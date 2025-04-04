
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import 'companyItem.dart';

class CompanyList extends StatefulWidget {
  final List<dynamic> companies;
  const CompanyList({Key? key, required this.companies}) : super(key: key);

  @override
  _CompanyListState createState() => _CompanyListState();
}

class _CompanyListState extends State<CompanyList> {
  final ScrollController _scrollController = ScrollController();
  final HomeController _homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      // عند الوصول لنهاية القائمة (أو بقربها) يتم تحميل المزيد
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        _homeController.loadMoreCompanies();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130.h,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        itemCount: widget.companies.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, i) => CompanyItem(company: widget.companies[i]),
      ),
    );
  }
}