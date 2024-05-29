import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:match_app/constants/constants.dart';
import 'package:match_app/features/screens/ads/banner_ad.dart';
import 'package:match_app/features/screens/home_screens/explore_page.dart';
import 'package:match_app/features/screens/home_screens/past_matches_page.dart';
import 'package:match_app/features/screens/home_screens/standings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController(initialPage: 0);

  int maxCount = 3;
  String appBarTitle = 'Live Matches';
  int _selectedIndex = 0;

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
      bottom:
          false, // This ensures that content is rendered below the system's bottom navigation bar
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
        bottomNavigationBar: CurvedNavigationBar(
          index: _selectedIndex,
          backgroundColor: Colors.grey[900]!, // Dark grey color
          color: Color.fromARGB(255, 0, 14, 119), // Color of the selected icon
          buttonBackgroundColor:
              Colors.grey[900], // Dark grey color for the button background
          items: [
            const CurvedNavigationBarItem(
              child: Icon(
                Icons.home,
                color: Colors.red, // Red color for the icon
              ),
              label: 'Home',
            ),
            const CurvedNavigationBarItem(
              child: Icon(
                Icons.sports_baseball_rounded,
                color: Colors.red, // Red color for the icon
              ),
              label: 'Schedule',
            ),
            const CurvedNavigationBarItem(
              child: Icon(
                Icons.stacked_line_chart_rounded,
                color: Colors.red, // Red color for the icon
              ),
              label: 'Standings',
            ),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            });
          },
        ),
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
