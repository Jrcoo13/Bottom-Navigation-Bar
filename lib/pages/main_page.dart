import 'package:bottom_navigation_bar/pages/home_page.dart';
import 'package:bottom_navigation_bar/pages/notification_page.dart';
import 'package:bottom_navigation_bar/pages/profile_page.dart';
import 'package:bottom_navigation_bar/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:fui_kit/fui_kit.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  int pageIndex = 0;
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      4,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );

    _animations = _controllers
        .map((controller) =>
            Tween<double>(begin: 1.0, end: 1.2).animate(controller))
        .toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: getFooter(pageIndex, screenSize),
      body: getBody(),
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: const [
        HomePage(),
        SearchPage(),
        NotificationPage(),
        ProfilePage(),
      ],
    );
  }

  Widget getFooter(int pageIndex, Size screenSize) {
    List bottomNavItems = [
      {
        'icon': RegularRounded.HOME,
        'label': 'Home',
        'color': Colors.grey.shade400,
        'iconSize': screenSize.height * 0.025
      },
      {
        'icon': RegularRounded.SEARCH,
        'label': 'Search',
        'color': Colors.grey.shade400,
        'iconSize': screenSize.height * 0.025
      },
      {
        'icon': RegularRounded.INBOX,
        'label': 'Inbox',
        'color': Colors.grey.shade400,
        'iconSize': screenSize.height * 0.025
      },
      {
        'icon': RegularRounded.USER,
        'label': 'Profile',
        'color': Colors.grey.shade400,
        'iconSize': screenSize.height * 0.025
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      height: screenSize.height * 0.085,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(bottomNavItems.length, (index) {
            return InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                selectedIndex(index);
              },
              child: AnimatedBuilder(
                animation: _animations[index],
                builder: (context, child) {
                  return Transform.scale(
                    scale: _animations[index].value,
                    child: child,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, top: 12, right: 12),
                  child: Column(
                    children: [
                      FUI(
                        bottomNavItems[index]['icon'],
                        color: pageIndex == index
                            ? Colors.black
                            : bottomNavItems[index]['color'],
                        height: bottomNavItems[index]['iconSize'],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        bottomNavItems[index]['label'],
                        style: TextStyle(
                          color: pageIndex == index
                              ? Colors.black
                              : bottomNavItems[index]['color'],
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void selectedIndex(int index) {
    if (pageIndex != index) {
      _controllers[pageIndex].reverse();
      _controllers[index].forward().then((_) => _controllers[index].reverse());
    } else {
      _controllers[index].forward().then((_) => _controllers[index].reverse());
    }

    setState(() {
      pageIndex = index;
    });
  }
}
