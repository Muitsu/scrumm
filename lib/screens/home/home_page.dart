import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrumm/screens/home/Responsive/mobile_home_body.dart';
import 'package:scrumm/screens/home/Responsive/tablet_home_body.dart';
import 'package:scrumm/screens/home/Responsive/web_home_body.dart';
import 'package:scrumm/screens/home/home_provider.dart';
import 'package:scrumm/widgets/custom_page_transition.dart';
import 'package:scrumm/widgets/responsive_layout.dart';
import '../manager/add_post_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: const ResponsiveLayout(
        mobileView: MobileHomeBody(),
        tabletView: TabletHomeBody(),
        webView: WebHomeBody(),
      ),
      floatingActionButton: context.watch<HomeProvider>().currentPage == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    CustomPageTransition.slideToPage(
                        page: const AddPostPage(), slide: SlideFrom.bottom));
              },
              tooltip: 'Create Scrum',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
