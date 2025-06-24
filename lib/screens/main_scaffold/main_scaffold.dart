import 'package:beyond_stock_app/screens/idea/idea_screen.dart';
import 'package:beyond_stock_app/screens/note/note_screen.dart';
import 'package:beyond_stock_app/screens/watchlist/screens/watchlist.dart';
import 'package:beyond_stock_app/view_model/bottom_nav_viewmodel.dart';
import 'package:beyond_stock_app/view_model/connectivity_viewmodel.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/snackbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_bottom_nav_bar.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late ConnectivityViewmodel _connectivityViewmodel;
  bool _wasDisconnectedOnce = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _connectivityViewmodel = context.read();
      _connectivityViewmodel.initializeConnectivity(_updateConnectionStatus);
    });
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    final isConnected = results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi);

    if (!isConnected) {
      // User just went offline
      _wasDisconnectedOnce = true;
      showOfflineMessage();
    } else if (_wasDisconnectedOnce) {
      // User was offline before and now came online
      showBackOnlineMessage();
      _wasDisconnectedOnce = false; // reset if you only want one-time alert
    }
  }

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
