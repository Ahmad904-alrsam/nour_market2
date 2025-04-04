import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerCarouselWidget extends StatefulWidget {
  final String header;
  final List<dynamic> banners; // يفترض أن كل بانر يحتوي على حقل image

  const BannerCarouselWidget(
      {Key? key, required this.header, required this.banners})
      : super(key: key);

  @override
  _BannerCarouselWidgetState createState() => _BannerCarouselWidgetState();
}

class _BannerCarouselWidgetState extends State<BannerCarouselWidget> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // قسم العنوان بنمط جذاب

        SizedBox(height: 12.h),
        // Carousel مع indicator
        SizedBox(
          height: 180.h,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CarouselSlider(
                items: widget.banners.map((banner) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: Colors.grey[200],
                    ),
                    child: CachedNetworkImage(
                      imageUrl: banner.image,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Icon(
                        Icons.image_not_supported_rounded,
                        size: 32.w,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 180.h,
                  autoPlay: true,
                  viewportFraction: 0.95,
                  enlargeCenterPage: true,
                  autoPlayInterval: Duration(seconds: 5),
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
              ),
              Positioned(
                bottom: 12.h,
                child: AnimatedSmoothIndicator(
                  activeIndex: _current,
                  count: widget.banners.length,
                  effect: WormEffect(
                    activeDotColor: Colors.blue[800]!,
                    dotColor: Colors.grey.shade300,
                    dotHeight: 6.w,
                    dotWidth: 6.w,
                    spacing: 5.w,
                    strokeWidth: 1.5.w,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
