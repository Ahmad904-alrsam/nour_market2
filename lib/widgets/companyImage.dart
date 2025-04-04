


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompanyImage extends StatelessWidget {
  final String? image;
  const CompanyImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: SizedBox(
        width: 65.w,
        height: 65.h,
        child: CachedNetworkImage(
          imageUrl: (image != null && image!.isNotEmpty)
              ? "https://nour-market.site$image"
              : '',
          fit: BoxFit.cover,
          memCacheWidth:
          (65.w * MediaQuery.of(context).devicePixelRatio).round(),
          placeholder: (_, __) => Container(
            width: 65.w,
            height: 65.h,
            color: Colors.grey[200],
          ),
          errorWidget: (_, __, ___) => Icon(
            Icons.business_rounded,
            size: 24.w,
            color: Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}