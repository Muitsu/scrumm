import 'package:flutter/material.dart';
import 'package:scrumm/screens/history/history_page.dart';
import 'package:scrumm/screens/home/home_page.dart';
import 'package:scrumm/screens/member/member_page.dart';

enum HomeSideBar {
  home(name: 'Dashboard', icon: Icons.home, page: MyHomePage()),
  history(
      name: 'History',
      icon: Icons.history,
      page: HistoryPage(showDrawer: true)),
  member(
      name: 'Members',
      icon: Icons.person_2,
      page: MembersPage(showDrawer: true)),
  ;

  const HomeSideBar(
      {required this.name, required this.icon, required this.page});
  final String name;
  final IconData icon;
  final Widget page;
}
