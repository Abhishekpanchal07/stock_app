import 'package:flutter/material.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  final List<WatchItem> watchlist = [
    WatchItem(name: 'Reliance Industries BSE Sensex Index Fund Direct Growth', priceChange: 47.88),
    WatchItem(name: 'Tata Consultancy Services Nifty200 Momentum 30 Index Fund', priceChange: 47.88),
    WatchItem(name: 'HDFC Bank BSE Sensex Index Fund Direct Growth', priceChange: 47.88),
    WatchItem(name: 'Infosys Nifty Next 50 Index Fund', priceChange: -47.88),
    WatchItem(name: 'Tata Consultancy Services Nifty200 Momentum 30 Index Fund', priceChange: 47.88),
  ];

  void _deleteItem(int index) {
    setState(() {
      watchlist.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist 1'),
        leading: const BackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              // Sorting logic here
            },
          ),
          IconButton(
            icon: const Icon(Icons.percent),
            onPressed: () {
              // Day change logic here
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: watchlist.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final item = watchlist[index];
          return Dismissible(
            key: ValueKey(item.name),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) => _deleteItem(index),
            child: Card(
              color: isDark ? Colors.grey[900] : Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  item.name,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.priceChange > 0
                          ? '+₹${item.priceChange.toStringAsFixed(2)}'
                          : '-₹${item.priceChange.abs().toStringAsFixed(2)}',
                      style: TextStyle(
                        color: item.priceChange >= 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '(0.54%)',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add stock logic
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Stocks'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Watchlist'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class WatchItem {
  final String name;
  final double priceChange;

  WatchItem({required this.name, required this.priceChange});
}
