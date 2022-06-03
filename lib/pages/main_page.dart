import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/forecast_page.dart';
import '../pages/cuaca_page.dart';
import '../pages/settings_page.dart';
import '../utils/bottom_navbar_index.dart';
import '../utils/forecast_notifier.dart';
import 'add_forecast_page.dart';

class MainPage extends StatelessWidget {
  final List<Widget> _pages = [
    const CuacaPage(),
    const ForecastPage(),
    SettingsPage(),
  ];

  MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: context.watch<BottomNavBarIndex>().currentIndex == 1
          ? AppBar(
        title: Text("Tambah Ramalan"),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary),
                  onPressed: () {
                    context.read<ForecastNotifier>().type = 'Jam';
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => AddForecastPage()));
                  },
                  child: Text("Jam"),
                ),
                TextButton(
                  style: TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary),
                  onPressed: () {
                    context.read<ForecastNotifier>().type = 'Hari';
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => AddForecastPage()));
                  },
                  child: Text("Hari"),
                ),
              ],
            )
          : null,
      body: _pages.elementAt(context.watch<BottomNavBarIndex>().currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) =>
            context.read<BottomNavBarIndex>().currentIndex = index,
        currentIndex: context.watch<BottomNavBarIndex>().currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.cloud_outlined,
            ),
            activeIcon: Icon(
              Icons.cloud,
            ),
            label: "Cuaca",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart_outlined),
            label: "Ramalan Cuaca",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings_outlined,
            ),
            activeIcon: Icon(
              Icons.settings,
            ),
            label: "Pengaturan",
          )
        ],
      ),
    );
  }
}