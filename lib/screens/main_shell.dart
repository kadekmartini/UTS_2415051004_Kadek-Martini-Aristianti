
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_theme.dart';
import '../providers/reading_provider.dart';
import 'home_screen.dart';
import 'discover_screen.dart';
import 'library_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      HomeScreen(
        onOpenProfile: _openProfile,
        onOpenLibrary: _openLibrary,
      ),
      const DiscoverScreen(),
      const LibraryScreen(),
      const ProfileScreen(),
    ];
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openProfile() {
    _onDestinationSelected(3);
  }

  void _openLibrary(String status) {
    context.read<ReadingProvider>().setStatusFilter(status);
    _onDestinationSelected(2);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;

        return Scaffold(
          backgroundColor: AppColors.cream,
          body: Row(
            children: [
              if (isWide) ...[
                NavigationRail(
                  backgroundColor: Colors.white,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onDestinationSelected,
                  labelType: NavigationRailLabelType.all,
                  minWidth: 76,
                  selectedIconTheme: const IconThemeData(
                    color: AppColors.forest,
                  ),
                  unselectedIconTheme: const IconThemeData(
                    color: AppColors.muted,
                  ),
                  selectedLabelTextStyle: const TextStyle(
                    color: AppColors.forest,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                  unselectedLabelTextStyle: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: Text('Beranda'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.explore_outlined),
                      selectedIcon: Icon(Icons.explore_rounded),
                      label: Text('Jelajah'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.bookmarks_outlined),
                      selectedIcon: Icon(Icons.bookmarks_rounded),
                      label: Text('Rak Saya'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline_rounded),
                      selectedIcon: Icon(Icons.person_rounded),
                      label: Text('Profil'),
                    ),
                  ],
                ),
                const VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: AppColors.line,
                ),
              ],
              Expanded(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: _pages,
                ),
              ),
            ],
          ),
          bottomNavigationBar: isWide
              ? null
              : NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onDestinationSelected,
                  backgroundColor: Colors.white,
                  indicatorColor: AppColors.mint,
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: 'Beranda',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.explore_outlined),
                      selectedIcon: Icon(Icons.explore_rounded),
                      label: 'Jelajah',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.bookmarks_outlined),
                      selectedIcon: Icon(Icons.bookmarks_rounded),
                      label: 'Rak Saya',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_outline_rounded),
                      selectedIcon: Icon(Icons.person_rounded),
                      label: 'Profil',
                    ),
                  ],
                ),
        );
      },
    );
  }
}
