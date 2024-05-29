import 'dart:ui';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:match_app/constants/constants.dart';
import 'package:match_app/features/screens/ads/banner_ad.dart';
import 'package:match_app/features/screens/home_screens/explore_page.dart';
import 'package:match_app/features/screens/home_screens/past_matches_page.dart';
import 'package:match_app/features/screens/home_screens/standings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController(initialPage: 0);
  final NotchBottomBarController _controller = NotchBottomBarController(index: 0);

  int maxCount = 3;
  String appBarTitle = 'Live Matches';

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> bottomBarPages = [
      LiveMatches(),
      const MatchesPage(),
      TournamentStandings(),
    ];
    return SafeArea(
      bottom: false, // This ensures that content is rendered below the system's bottom navigation bar
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
        ),
        drawer: const Drawer(),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            _updateAppBarTitle(index);
          },
          children: bottomBarPages,
        ), // This line ensures that the body extends behind the bottom navigation bar
        bottomNavigationBar: (bottomBarPages.length <= maxCount)
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: AnimatedNotchBottomBar(
                      notchBottomBarController: _controller,
                      color: const Color.fromARGB(95, 74, 86, 99),
                      showLabel: true,
                      textOverflow: TextOverflow.visible,
                      maxLine: 1,
                      shadowElevation: 5,
                      kBottomRadius: 28.0,
                      notchColor: const Color.fromARGB(95, 74, 86, 99),
                      removeMargins: false,
                      bottomBarHeight: navBarWidth(context) / 100,
                      bottomBarWidth: navBarWidth(context),
                      showShadow: false,
                      durationInMilliSeconds: 300,
                      itemLabelStyle: const TextStyle(fontSize: 10),
                      elevation: 1,
                      bottomBarItems: const [
                        BottomBarItem(
                          inActiveItem: Icon(Icons.home_filled, color: Colors.blueGrey),
                          activeItem: Icon(Icons.home_filled, color: Colors.blueAccent),
                        ),
                        BottomBarItem(
                          inActiveItem: Icon(Icons.sports_basketball_sharp, color: Colors.blueGrey),
                          activeItem: Icon(Icons.sports_baseball_sharp, color: Colors.blueAccent),
                        ),
                        BottomBarItem(
                          inActiveItem: Icon(Icons.stacked_line_chart, color: Colors.blueGrey),
                          activeItem: Icon(Icons.stacked_line_chart, color: Colors.blueAccent),
                        ),
                      ],
                      onTap: (index) {
                        _pageController.jumpToPage(index);
                      },
                      kIconSize: 24.0,
                    ),
                  ),
                  const BannerAdWidget(), // Add the BannerAdWidget here
                ],
              )
            : null,
      ),
    );
  }

  void _updateAppBarTitle(int index) {
    setState(() {
      if (index == 0) {
        appBarTitle = 'Live Matches';
      } else if (index == 1) {
        appBarTitle = 'Matches';
      } else if (index == 2) {
        appBarTitle = 'Standings';
      }
    });
  }
}
