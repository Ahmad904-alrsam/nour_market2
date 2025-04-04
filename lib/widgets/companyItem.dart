
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../views/productpage_Companies.dart';
import 'companyImage.dart';

class CompanyItem extends StatelessWidget {
  final dynamic company;
  const CompanyItem({Key? key, required this.company}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => ProductPageCompanies(),
          arguments: {'companyId': company.id}),
      child: Container(
        width: 80.w,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          children: [
            CompanyImage(image: company.image),
            SizedBox(height: 6.h),
            Text(
              company.name,
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}