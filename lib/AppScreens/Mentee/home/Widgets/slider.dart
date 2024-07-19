import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mentorapp/AppScreens/constant.dart';

class SliderWidget extends StatefulWidget {
  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  late Timer _timer;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      child: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: [
          SliderItem(
            image:
                'https://lh5.googleusercontent.com/0APfOCbcqrfOdTrJ_9Gt5NM0jZHGQONM-fLx6c9r7J6Xq8dkkjD4j0Ue3MUZNXCiVAKm-jdjUIQu5f7yH5PTbUYViaIDsKISPqQ0Z4sKpXfOTFQskShYXF3JtHx85jwuC_-R9Zkjyjp-2UevrZ3e2Y4',
            title: 'Connect with Mentors',
            subtitle: 'Get guidance from experienced professionals',
            currentPage: _currentPage,
            index: 0,
          ),
          SliderItem(
            image:
                'https://www.peoplegrove.com/wp-content/uploads/2022/07/8G2tiC2F-alumni-mentoring-00-header.png',
            title: 'Learn from the Best',
            subtitle: 'Access a vast library of study resources',
            currentPage: _currentPage,
            index: 1,
          ),
          SliderItem(
            image:
                'https://www.marketing91.com/wp-content/uploads/2020/06/Advantages-of-mentoring.jpg',
            title: 'Grow Your Career',
            subtitle: 'Get ahead in your career with our mentorship program',
            currentPage: _currentPage,
            index: 2,
          ),
        ],
      ),
    );
  }
}

class SliderItem extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final int currentPage;
  final int index;

  SliderItem({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.currentPage,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 170, // Adjusted height to fit within larger container
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Container(
              margin: EdgeInsets.only(right: 5),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentPage == index ? primaryColor : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }
}
