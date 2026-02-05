import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'home_screen.dart';
import 'zikir_screen.dart';
import '../widgets/side_menu.dart';
import 'qibla_screen.dart';
import 'quran_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  // Sayfalar
  final List<Widget> _pages = [
    const HomeScreen(),
    const QiblaScreen(),
    const ZikirScreen(), // Zikirmatik eklendi
    const QuranScreen(),
  ];

  // Başlıklar
  final List<String> _titles = [
    "Ana Sayfa",
    "Kıble Bulucu",
    "Zikirmatik",
    "Kuran-ı Kerim",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar ekledik ki hamburger menü butonu çıksın
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      drawer: const SideMenu(), // Yan menüyü buraya ekledik

      body: _pages[_currentIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        indicatorColor: Colors.teal.shade100,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Colors.teal),
            label: 'Ana Sayfa',
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.compass),
            selectedIcon: Icon(CupertinoIcons.compass_fill, color: Colors.teal),
            label: 'Kıble',
          ),
          NavigationDestination(
            icon: Icon(Icons.touch_app_outlined),
            selectedIcon: Icon(Icons.touch_app, color: Colors.teal),
            label: 'Zikir',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book, color: Colors.teal),
            label: 'Kuran',
          ),
        ],
      ),
    );
  }
}
