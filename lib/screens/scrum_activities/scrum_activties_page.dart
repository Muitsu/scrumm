import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrumm/screens/home/home_drawer.dart';
import 'package:scrumm/screens/scrum_activities/scrum_activities_provider.dart';
import 'package:scrumm/widgets/responsive_layout.dart';

import '../../widgets/custom_page_transition.dart';
import '../user_info/user_info_page.dart';

class ScrumActivitiesPage extends StatefulWidget {
  final bool showDrawer;
  const ScrumActivitiesPage({super.key, this.showDrawer = false});

  @override
  State<ScrumActivitiesPage> createState() => _ScrumActivitiesPageState();
}

class _ScrumActivitiesPageState extends State<ScrumActivitiesPage> {
  late ScrumActivitiesProvider scrumActivitiesProvider;
  @override
  void initState() {
    super.initState();
    scrumActivitiesProvider = Provider.of(context, listen: false);
    scrumActivitiesProvider.fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: !widget.showDrawer
          ? null
          : (MediaQuery.sizeOf(context).width < 850
              ? const HomeDrawer()
              : null),
      appBar: AppBar(),
      body: ResponsiveLayout(
        mobileView: _userPageBody(),
        tabletView: Row(
          children: [
            SizedBox(
                width: MediaQuery.sizeOf(context).width *
                    (widget.showDrawer ? 0 : .2)),
            Expanded(flex: 2, child: _userPageBody()),
            SizedBox(
                width: MediaQuery.sizeOf(context).width *
                    (widget.showDrawer ? 0 : .2)),
          ],
        ),
        webView: Row(
          children: [
            SizedBox(
                width: MediaQuery.sizeOf(context).width *
                    (widget.showDrawer ? 0 : .2)),
            Expanded(flex: 2, child: _userPageBody()),
            SizedBox(
                width: MediaQuery.sizeOf(context).width *
                    (widget.showDrawer ? 0 : .2)),
          ],
        ),
      ),
    );
  }

  _userPageBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ListView(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Scrumm activity',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'NO SCRUM - ${context.watch<ScrumActivitiesProvider>().userEnable?.length ?? 0}',
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.grey),
            ),
          ),
          ...List.generate(
              context.watch<ScrumActivitiesProvider>().userEnable!.length,
              (index) => _listTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          CustomPageTransition.slideToPage(
                              page: UserInfoPage(
                                name: context
                                    .read<ScrumActivitiesProvider>()
                                    .userEnable![index]
                                    .name,
                                userId: context
                                    .read<ScrumActivitiesProvider>()
                                    .userEnable![index]
                                    .id!,
                              ),
                              slide: SlideFrom.right));
                    },
                    name: context
                            .watch<ScrumActivitiesProvider>()
                            .userEnable?[index]
                            .name ??
                        '-',
                    id: context
                            .watch<ScrumActivitiesProvider>()
                            .userEnable?[index]
                            .id
                            .toString() ??
                        '-',
                  )),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'ALREADY CREATE - ${context.watch<ScrumActivitiesProvider>().userDisable?.length ?? 0}',
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.grey),
            ),
          ),
          ...List.generate(
              context.watch<ScrumActivitiesProvider>().userDisable!.length,
              (index) => _listTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          CustomPageTransition.slideToPage(
                              page: UserInfoPage(
                                name: context
                                    .read<ScrumActivitiesProvider>()
                                    .userDisable![index]
                                    .name,
                                userId: context
                                    .read<ScrumActivitiesProvider>()
                                    .userDisable![index]
                                    .id!,
                              ),
                              slide: SlideFrom.right));
                    },
                    name: context
                            .watch<ScrumActivitiesProvider>()
                            .userDisable?[index]
                            .name ??
                        '-',
                    id: context
                            .watch<ScrumActivitiesProvider>()
                            .userDisable?[index]
                            .id
                            .toString() ??
                        '-',
                  )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  _listTile(
      {required String name, required String id, void Function()? onTap}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: EdgeInsets.zero,
          leading: const CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: Text(name, maxLines: 1),
          subtitle: Text(id),
        ),
        const Divider(indent: 30, endIndent: 10, height: 0)
      ],
    );
  }
}
