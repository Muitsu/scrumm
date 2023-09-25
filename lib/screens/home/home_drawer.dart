import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrumm/app_theme.dart';
import 'package:scrumm/screens/home/home_constant.dart';
import 'package:scrumm/screens/home/home_provider.dart';

class HomeDrawer extends StatelessWidget {
  final bool isTablet;
  const HomeDrawer({super.key, this.isTablet = false});
  final sideBar = HomeSideBar.values;

  @override
  Widget build(BuildContext context) {
    if (isTablet) {
      return NavigationRail(
        selectedIndex: context.watch<HomeProvider>().currentPage,
        trailing: _themeButton(context),
        leading: const Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 50),
          child: Icon(
            Icons.bolt,
            color: Colors.blue,
            size: 34,
          ),
        ),
        onDestinationSelected: (int index) {
          context.read<HomeProvider>().changePage(context, index: index);
        },
        labelType: NavigationRailLabelType.all,
        destinations: <NavigationRailDestination>[
          ...List.generate(
            sideBar.length,
            (index) => NavigationRailDestination(
              padding: const EdgeInsets.symmetric(vertical: 6),
              icon: Icon(
                sideBar[index].icon,
                size: 34,
              ),
              selectedIcon: Icon(
                sideBar[index].icon,
                size: 34,
              ),
              label: Text(sideBar[index].name),
            ),
          )
        ],
        selectedIconTheme: const IconThemeData(color: Colors.white),
        unselectedIconTheme: const IconThemeData(color: Colors.black),
        selectedLabelTextStyle: const TextStyle(color: Colors.black),
      );
    }

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 50, 8, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'SCRUMMM',
                  style: TextStyle(color: Colors.blue, fontSize: 24),
                ),
                Icon(Icons.bolt, color: Colors.blue)
              ],
            ),
          ),
          ...List.generate(
            sideBar.length,
            (index) => ListTile(
              shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.horizontal(right: Radius.circular(50)),
              ),
              tileColor: context.watch<HomeProvider>().currentPage == index
                  ? Colors.black12
                  : null,
              onTap: () {
                context.read<HomeProvider>().changePage(context, index: index);
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: Icon(sideBar[index].icon),
              title: Text(sideBar[index].name),
            ),
          ),
          _themeButton(context)
        ],
      ),
    );
  }

  _themeButton(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: IconButton(
              onPressed: () {
                context.read<AppThemeProvider>().toggleTheme();
              },
              icon: Icon(context.watch<AppThemeProvider>().isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode)),
        ),
      ),
    );
  }
}
