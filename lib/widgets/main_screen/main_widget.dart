import 'package:flutter/material.dart';
import 'package:movies_app_tmbd/domain/data_providers/session_data_provider.dart';
import 'package:movies_app_tmbd/library/Widgets/inherited/provider.dart';
import 'package:movies_app_tmbd/widgets/main_screen/main_screen_model.dart';
import 'package:movies_app_tmbd/widgets/movie_list_screen/movie_list_model.dart';

import '../movie_list_screen/movie_list_widget.dart';

class MainMidget extends StatefulWidget {
  const MainMidget({Key? key}) : super(key: key);
  @override
  State<MainMidget> createState() => _MainMidgetState();
}

class _MainMidgetState extends State<MainMidget> {
  int _selectedTab = 0;
  final movieListModel = MovieListModel();

  _onSelectTab(int index) {
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    movieListModel.setupLocale(context);
  }

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.read<MainScreenModel>(context);
    print(model);
    return Scaffold(
      appBar: AppBar(
        title: const Text('TMBD'),
        actions: [
          IconButton(onPressed: () =>  SessionDataProvider().setSessionId(null), icon: const Icon(Icons.logout))
        ],
      ),
      body: IndexedStack(
        index: _selectedTab,
        children:  [
          const Text('НОВОСТИ'),
         NotifierProvider(create: ()=> movieListModel,isManagingModel: false, child: const MovieListWidget()),
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
