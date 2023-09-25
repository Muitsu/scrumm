import 'package:flutter/material.dart';
import 'package:scrumm/screens/home/home_drawer.dart';

class HistoryPage extends StatefulWidget {
  final bool showDrawer;
  const HistoryPage({super.key, this.showDrawer = false});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: !widget.showDrawer
          ? null
          : (MediaQuery.sizeOf(context).width < 850
              ? const HomeDrawer()
              : null),
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: ListView(
          children: const [
            SizedBox(height: 20),
            Text(
              'History',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
