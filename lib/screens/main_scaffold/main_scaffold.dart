import 'package:beyond_stock_app/screens/idea/idea_screen.dart';
import 'package:beyond_stock_app/screens/note/note_screen.dart';
import 'package:beyond_stock_app/screens/watchlist/screens/watchlist.dart';
import 'package:beyond_stock_app/view_model/bottom_nav_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_bottom_nav_bar.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = context.watch<BottomNavViewmodel>().selectedIndex;

    final List<Widget> screens = const [
      WatchlistScreen(),
      NoteScreen(),
      IdeaScreen(),
    ];

    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
