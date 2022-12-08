import 'package:flutter/material.dart';
import 'package:movies_app_tmbd/navigation/main_navigation.dart';

class MainMidget extends StatefulWidget {
  const MainMidget({Key? key, required this.screenFactory}) : super(key: key);
  final ScreenFactory screenFactory;
  @override
  State<MainMidget> createState() => _MainMidgetState();
}

class _MainMidgetState extends State<MainMidget> {
  int _selectedTab = 0;


  _onSelectTab(int index) {
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TMBD'),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children:  [
          const Text('НОВОСТИ'),
          widget.screenFactory.makePopularMovieListWidget(),
          widget.screenFactory.makeTopRatedListWidget(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.newspaper),label: 'Новости'),
          BottomNavigationBarItem(icon: Icon(Icons.movie_creation),label: ' Популярные'),
          BottomNavigationBarItem(icon: Icon(Icons.movie_filter_sharp),label: 'Рейтинговые'),
        ],
        onTap: _onSelectTab,
        currentIndex: _selectedTab,
      ),
    );
  }
}
