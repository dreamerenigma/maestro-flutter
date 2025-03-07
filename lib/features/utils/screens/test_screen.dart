import 'dart:developer';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:maestro/common/widgets/app_bar/app_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: Text('Tests', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cast, size: 23),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCarouselTest(context),
        ],
      ),
    );
  }

  Widget _buildCarouselTest(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Карусель
          CarouselSlider(
            options: CarouselOptions(
              height: 400,
              viewportFraction: 0.84,
              enableInfiniteScroll: false,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentPage = index;
                  log('Current page changed to: $_currentPage');
                });
              },
            ),
            items: [
              Container(
                color: Colors.blue,
                child: Center(
                  child: Text(
                    'Item 1',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
              Container(
                color: Colors.green,
                child: Center(
                  child: Text(
                    'Item 2',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
              Container(
                color: Colors.orange,
                child: Center(
                  child: Text(
                    'Item 3',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
            ],
          ),

          // Индикатор
          const SizedBox(height: 20),
          SmoothPageIndicator(
            controller: PageController(initialPage: _currentPage), // Не используем внешний PageController
            count: 3,
            effect: SlideEffect(
              dotWidth: 10,
              dotHeight: 10,
              activeDotColor: AppColors.white,
              dotColor: AppColors.darkerGrey,
              spacing: 8,
            ),
          ),
        ],
      ),
    );
  }
}
