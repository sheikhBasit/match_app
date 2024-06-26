import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:match_app/common_widgets/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:match_app/common_widgets/user_subscription.dart';
import 'package:match_app/features/screens/ads/banner_ad.dart';
import 'package:match_app/features/screens/drawer_pages/privacy_policy_page.dart';
import 'package:match_app/features/screens/drawer_pages/terms_of_service_page.dart';
import 'package:match_app/features/screens/home_screens/explore_page.dart';
import 'package:match_app/features/screens/home_screens/matches_page.dart';
import 'package:match_app/features/screens/home_screens/standings_page.dart';
import 'package:match_app/features/controllers/live_matches_controller.dart'; // Import the controller
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController(initialPage: 0);

  int maxCount = 3;
  String appBarTitle = 'Today Matches';
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
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            appBarTitle,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color.fromARGB(255, 240, 240, 240)
                      : Colors.black,
                ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildDrawerHeader(),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Privacy Policy'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('Terms of Service'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TermsOfServicePage()),
                  );
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  _updateAppBarTitle(index);
                },
                children: bottomBarPages,
              ),
            ),
             const BannerAdWidget(),
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          index: _selectedIndex,
          backgroundColor: Colors.grey[900]!,
          color: const Color.fromARGB(255, 36, 37, 46),
          buttonBackgroundColor: Colors.grey[900],
          items: const [
            CurvedNavigationBarItem(
              child: Icon(
                Icons.home,
                color: Colors.red,
              ),
              labelStyle: TextStyle(
                color: Colors.white,
              ),
              label: 'Home',
            ),
            CurvedNavigationBarItem(
              child: Icon(
                Icons.sports_baseball_rounded,
                color: Colors.red,
              ),
              labelStyle: TextStyle(
                color: Colors.white,
              ),
              label: 'Schedule',
            ),
            CurvedNavigationBarItem(
              child: Icon(
                Icons.stacked_line_chart_rounded,
                color: Colors.red,
              ),
              labelStyle: TextStyle(
                color: Colors.white,
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

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 109, 161, 203),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/logo/logo.png',
                width: 50,
                height: 50,
              ),
              const Text(
                'Baseball Live',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
