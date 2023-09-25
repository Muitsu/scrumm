import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrumm/screens/user_info/user_info_provider.dart';
import 'package:scrumm/widgets/responsive_layout.dart';
import 'package:scrumm/widgets/user_posting.dart';

import '../../widgets/custom_page_transition.dart';
import '../manager/manage_post_page.dart';
import '../manager/manage_post_provider.dart';

class UserInfoPage extends StatefulWidget {
  final String name;
  final int userId;
  const UserInfoPage({super.key, required this.name, required this.userId});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  late UserInfoProvider userInfoProvider;
  int dateIndex = 0;
  @override
  void initState() {
    super.initState();
    userInfoProvider = Provider.of(context, listen: false);
    userInfoProvider.fetchUserPostingById(userId: widget.userId);
  }

  shortenName(String name) {
    var split = name.split(' ');
    if (split.length >= 2) {
      return split[0][0].toUpperCase() + split[1][0].toUpperCase();
    } else {
      return name[0].toUpperCase() + name[1].toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('${widget.name}`s Profile', maxLines: 1),
      ),
      body: ResponsiveLayout(
        mobileView: _userInfoBody(),
        tabletView: Row(
          children: [
            SizedBox(width: MediaQuery.sizeOf(context).width * .2),
            Expanded(flex: 2, child: _userInfoBody()),
            SizedBox(width: MediaQuery.sizeOf(context).width * .2),
          ],
        ),
        webView: Row(
          children: [
            SizedBox(width: MediaQuery.sizeOf(context).width * .3),
            Expanded(flex: 2, child: _userInfoBody()),
            SizedBox(width: MediaQuery.sizeOf(context).width * .3),
          ],
        ),
      ),
    );
  }

  _userInfoBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 120,
                color: Colors.blue,
              ),
              Positioned(
                top: 30,
                left: 10,
                child: CircleAvatar(
                  radius: 70,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: Center(
                        child: Text(
                      shortenName(widget.name),
                      style: const TextStyle(fontSize: 34, color: Colors.blue),
                    )),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 55),
          Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: Text(
              widget.name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: Text(widget.userId.toString()),
          ),
          const SizedBox(height: 20),
          Container(
            height: 10,
            width: double.infinity,
            color: Colors.grey.withOpacity(0.25),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 14.0, top: 16),
            child: Text(
              'Today Scrum',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildTodayPosting(),
          Container(
            height: 10,
            width: double.infinity,
            color: Colors.grey.withOpacity(0.25),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 14.0, top: 16),
            child: Text(
              'Past Scrum',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildPastPosting(),
          const SizedBox(
            height: 100,
            child: Center(
                child: Text(
              'You have reached the end of content',
              style: TextStyle(color: Colors.grey),
            )),
          ),
        ],
      ),
    );
  }

  _buildTodayPosting() {
    if (context.watch<UserInfoProvider>().todayPosting == null) {
      return Container(
        color: Colors.grey.withOpacity(0.25),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 30),
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: const Center(child: Text('This user not create their scrum')),
      );
    }
    return UserPosting(
        hideTop: true,
        name: widget.name,
        todayPlans:
            context.watch<UserInfoProvider>().todayPosting?.todayPlans! ?? '',
        blocker:
            context.watch<UserInfoProvider>().todayPosting?.blocker! ?? '');
  }

  _buildPastPosting() {
    if (context.watch<UserInfoProvider>().userPosting == null ||
        context.watch<UserInfoProvider>().userPosting!.isEmpty) {
      return Container(
        color: Colors.grey.withOpacity(0.25),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 30),
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: const Center(child: Text('Shhh... this user got no scrum')),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                context.watch<UserInfoProvider>().userPosting?.length ?? 0,
                (index) => DateChipButton(
                  onTap: () => setState(() => dateIndex = index),
                  margin: EdgeInsets.only(
                      left: index == 0 ? 12 : 6,
                      top: 10,
                      right: index ==
                              (context
                                      .read<UserInfoProvider>()
                                      .userPosting!
                                      .length -
                                  1)
                          ? 10
                          : 0),
                  date: context
                          .watch<UserInfoProvider>()
                          .userPosting?[index]
                          .date! ??
                      '',
                  isSelected: index == dateIndex,
                ),
              ),
            )),
        const SizedBox(height: 8),
        UserPosting(
          hideTop: true,
          showCopy: true,
          name: context
                  .watch<UserInfoProvider>()
                  .userPosting?[dateIndex]
                  .username! ??
              '',
          todayPlans: context
                  .watch<UserInfoProvider>()
                  .userPosting?[dateIndex]
                  .todayPlans! ??
              '',
          blocker: context
                  .watch<UserInfoProvider>()
                  .userPosting?[dateIndex]
                  .blocker! ??
              '',
        ),
        const Divider(
          height: 0,
          indent: 10,
          endIndent: 10,
        ),
        GestureDetector(
          onTap: () {
            context.read<ManagePostProvider>().setPosting(
                post: context.read<UserInfoProvider>().userPosting![dateIndex]);
            Navigator.push(
              context,
              CustomPageTransition.slideToPage(
                  page: const ManagePostPage(), slide: SlideFrom.bottom),
            );
          },
          child: Container(
            height: 60,
            width: double.infinity,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Edit'),
                Icon(Icons.edit_note_outlined),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class DateChipButton extends StatelessWidget {
  final bool isSelected;
  final String date;
  final EdgeInsetsGeometry? margin;
  final void Function()? onTap;
  const DateChipButton({
    super.key,
    required this.isSelected,
    required this.date,
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        decoration: ShapeDecoration(
          color: isSelected ? Colors.blue : Colors.grey.shade200,
          shape: const StadiumBorder(),
        ),
        child: Text(
          date,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
