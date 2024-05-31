import 'package:flutter/material.dart';
import 'package:match_app/common_widgets/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:match_app/common_widgets/user_subscription.dart';
import 'package:match_app/features/screens/ads/banner_ad.dart'; // Import BannerAdWidget
import 'package:match_app/features/screens/drawer_pages/privacy_policy_page.dart';
import 'package:match_app/features/screens/drawer_pages/terms_of_service_page.dart';
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
      bottom: false, // This ensures that content is rendered below the system's bottom navigation bar
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            appBarTitle,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.brightness_6),
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
            ),
          ],
        ),
        drawer: const Drawer(),
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
            if (!UserSubscription.isSubscribed) BannerAdWidget(), // Conditionally show BannerAdWidget
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          index: _selectedIndex,
          backgroundColor: Colors.grey[900]!, // Dark grey color
          color: const Color.fromARGB(255, 36, 37, 46), // Color of the selected icon
          buttonBackgroundColor: Colors.grey[900], // Dark grey color for the button background
          items: const [
            CurvedNavigationBarItem(
              child: Icon(
                Icons.home,
                color: Colors.red, // Red color for the icon
              ),
          labelStyle: TextStyle(
            color:
           Colors.white , // Set label color based on theme
        ),    label: 'Home',
            ),
            CurvedNavigationBarItem(
              child: Icon(
                Icons.sports_baseball_rounded,
                color: Colors.red, // Red color for the icon
              ),
              labelStyle: TextStyle(
            color:
           Colors.white , // Set label color based on theme
        ),
              label: 'Schedule',
            ),
            CurvedNavigationBarItem(
               labelStyle: TextStyle(
            color:
           Colors.white , // Set label color based on theme
        ),
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

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 0, 39, 71),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDrawerItem(
            title: 'Privacy Policy',
            icon: Icons.privacy_tip,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrivacyPolicyPage(),
                ),
              );
            },
          ),
          _buildDrawerItem(
            title: 'Terms of Service',
            icon: Icons.description,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TermsOfServicePage(),
                ),
              );
            },
          ),
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
