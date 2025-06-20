import 'package:beyond_stock_app/core/constants/color_constants.dart';
import 'package:beyond_stock_app/core/constants/string_constants.dart';
import 'package:beyond_stock_app/screens/watchlist/widget/stock_filter_buttons.dart';
import 'package:beyond_stock_app/screens/watchlist/widget/stock_list_view.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.blackColor,
      appBar: CustomAppBar(
        backgroundColor: ColorConstants.blackColor,
        title: StringConstants.watchList1,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: ColorConstants.scaffoldBgColor,
            borderRadius: BorderRadius.circular(25)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: SortFilterButtons(),
            ),
            Divider(color: ColorConstants.blackColor, thickness: 1, height: 1),
            Expanded(child: StockListView()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorConstants.addButtonColor,
        shape: CircleBorder(),
        onPressed: () {},
        child: const Icon(Icons.add, color: ColorConstants.blackColor),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1C1C1E),
        selectedItemColor: const Color(0xFF00D09C),
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_line_chart),
            label: 'Stocks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {},
      ),
    );
  }
}
