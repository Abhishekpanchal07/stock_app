import 'package:beyond_stock_app/core/constants/parameter_key_constants.dart';
import 'package:beyond_stock_app/core/constants/route_constants.dart';
import 'package:beyond_stock_app/screens/add_stock/add_stock.dart';
import 'package:beyond_stock_app/screens/idea/idea_screen.dart';
import 'package:beyond_stock_app/screens/main_scaffold/main_scaffold.dart';
import 'package:beyond_stock_app/screens/note/note_screen.dart';
import 'package:beyond_stock_app/screens/stock_detail/stock_detail_screen.dart';
import 'package:beyond_stock_app/screens/watchlist/screens/watchlist.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:go_router/go_router.dart';

class MyRoutes {
  static Future<GoRouter> initializeRouter() async {
    return GoRouter(
        initialLocation: RouteConstants.mainScaffoldScreen,
        observers: [
          BotToastNavigatorObserver()
        ], // ✅ Add this here
        routes: [
          GoRoute(
            path: RouteConstants.mainScaffoldScreen,
            name: RouteConstants.mainScaffoldScreen,
            builder: (context, state) {
              return MainScaffold();
            },
          ),
          GoRoute(
            path: RouteConstants.noteScreen,
            name: RouteConstants.noteScreen,
            builder: (context, state) {
              return NoteScreen();
            },
          ),
          GoRoute(
            path: RouteConstants.ideaScreen,
            name: RouteConstants.ideaScreen,
            builder: (context, state) {
              return IdeaScreen();
            },
          ),
          GoRoute(
            path: RouteConstants.watchlistScreen,
            name: RouteConstants.watchlistScreen,
            builder: (context, state) {
              return WatchlistScreen();
            },
          ),
          GoRoute(
            path: RouteConstants.addStockScreen,
            name: RouteConstants.addStockScreen,
            builder: (context, state) {
              return AddStock();
            },
          ),
          GoRoute(
            path: RouteConstants.stockDetailScreen,
            name: RouteConstants.stockDetailScreen,
            builder: (context, state) {
              final data = state.extra
                  as Map<String, dynamic>; // Extracts extra parameters.
              return StockDetailScreen(
                stockName: data[ParameterKeyConstants.stockName],
                stockSymbol: data[ParameterKeyConstants.stockSymbol],
              );
            },
          )
        ]);
  }
}
