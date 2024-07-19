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
                'https://img.freepik.com/free-vector/businessman-planning-events-deadlines-agenda_74855-6274.jpg',
            title: 'Book Your Meeeting',
            subtitle: 'Get guidance from experienced professionals',
            currentPage: _currentPage,
            index: 0,
          ),
          SliderItem(
            image:
                'https://img.freepik.com/premium-vector/online-meeting_373887-1663.jpg',
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
          height: 160, // Adjusted height
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
