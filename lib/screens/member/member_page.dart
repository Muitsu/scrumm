import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrumm/screens/home/home_drawer.dart';
import 'package:scrumm/screens/member/member_provider.dart';
import 'package:scrumm/screens/user_info/user_info_page.dart';
import 'package:scrumm/widgets/custom_page_transition.dart';
import 'package:scrumm/widgets/responsive_layout.dart';

class MembersPage extends StatefulWidget {
  final bool showDrawer;
  const MembersPage({super.key, this.showDrawer = false});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  late MemberProvider memberProvider;
  @override
  void initState() {
    super.initState();
    memberProvider = Provider.of(context, listen: false);
    memberProvider.fetchAllMembers();
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
            'Scrumm members',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(
              context.watch<MemberProvider>().allUser?.length ?? 0,
              (index) => _listTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          CustomPageTransition.slideToPage(
                              page: UserInfoPage(
                                name: context
                                    .read<MemberProvider>()
                                    .allUser![index]
                                    .name,
                                userId: context
                                    .read<MemberProvider>()
                                    .allUser![index]
                                    .id!,
                              ),
                              slide: SlideFrom.right));
                    },
                    name:
                        context.watch<MemberProvider>().allUser?[index].name ??
                            '-',
                    id: context
                            .watch<MemberProvider>()
                            .allUser?[index]
                            .id
                            .toString() ??
                        '-',
                  )),
          const SizedBox(height: 30),
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
