import 'package:flutter/material.dart';
import 'package:movies_app_tmbd/domain/factory/screen_factory.dart';


class MainMidget extends StatefulWidget {
  const MainMidget({Key? key}) : super(key: key);
  @override
  State<MainMidget> createState() => _MainMidgetState();
}

class _MainMidgetState extends State<MainMidget> {
  int _selectedTab = 0;
  final _screenFactory = ScreenFactory();

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
          _screenFactory.makeMovieListWidget(),
          const Text('СЕРИАЛЫ'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.newspaper),label: 'news'),
          BottomNavigationBarItem(icon: Icon(Icons.movie_creation),label: 'movies'),
          BottomNavigationBarItem(icon: Icon(Icons.movie_filter_sharp),label: 'series'),
        ],
        onTap: _onSelectTab,
        currentIndex: _selectedTab,
      ),
    );
  }
}
