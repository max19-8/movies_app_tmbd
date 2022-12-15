import 'package:flutter/material.dart';
import 'package:movies_app_tmbd/data/services/auth_service.dart';
import 'package:movies_app_tmbd/navigation/main_navigation.dart';
import 'package:movies_app_tmbd/navigation/main_navigation_actions.dart';

class MainMidget extends StatefulWidget {
  final AuthService authService;
  final  MainNavigationActions navigationActions;
  final ScreenFactory screenFactory;
  const MainMidget({Key? key, required this.screenFactory,required this.authService, required this.navigationActions}) : super(key: key);

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
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              widget.authService.logout();
              widget.navigationActions.resetNavigation(context);
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedTab,
        children:  [
          widget.screenFactory.makeNewsWidget(),
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
