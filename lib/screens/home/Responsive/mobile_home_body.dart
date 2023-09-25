import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrumm/gsheets/models/posting_model.dart';
import 'package:scrumm/screens/home/home_constant.dart';
import 'package:scrumm/screens/home/home_drawer.dart';
import 'package:scrumm/screens/home/home_provider.dart';
import 'package:scrumm/screens/manager/manage_post_page.dart';
import 'package:scrumm/screens/manager/manage_post_provider.dart';
import 'package:scrumm/screens/story/story_page.dart';
import 'package:scrumm/screens/story/story_provider.dart';
import 'package:scrumm/screens/user_info/user_info_page.dart';
import 'package:scrumm/screens/scrum_activities/scrum_activties_page.dart';
import 'package:scrumm/widgets/custom_page_transition.dart';
import 'package:scrumm/widgets/user_posting.dart';
import 'package:scrumm/widgets/circle_user.dart';

class MobileHomeBody extends StatefulWidget {
  const MobileHomeBody({super.key});

  @override
  State<MobileHomeBody> createState() => _MobileHomeBodyState();
}

class _MobileHomeBodyState extends State<MobileHomeBody> {
  List<PostingModel> postings = [];
  late HomeProvider homeProvider;
  @override
  void initState() {
    super.initState();
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    homeProvider.fetchTodayPosting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeDrawer(),
      body: IndexedStack(
        index: context.watch<HomeProvider>().currentPage,
        children: [
          home(context),
          HomeSideBar.history.page,
          HomeSideBar.member.page
        ],
      ),
    );
  }

  CustomScrollView home(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        SliverAppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SCRUMMM',
                style: TextStyle(color: Colors.blue),
              ),
              Icon(Icons.bolt, color: Colors.blue)
            ],
          ),
          floating: true,
          centerTitle: true,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        ),
        CupertinoSliverRefreshControl(
          onRefresh: () => homeProvider.fetchTodayPosting(),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text(
                        'Today Scrum',
                        style: TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            CustomPageTransition.slideToPage(
                                page: const ScrumActivitiesPage(),
                                slide: SlideFrom.right)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: ShapeDecoration(
                            color: Colors.blueAccent.shade100,
                            shape: const StadiumBorder(),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.people, color: Colors.white),
                              const SizedBox(width: 5),
                              Text(
                                '${context.watch<HomeProvider>().totalPost} / ${context.watch<HomeProvider>().totalUser}',
                                style: const TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                _buildStory(),
                const Divider(height: 0),
                ..._buildPostings(),
                const SizedBox(
                  height: 100,
                  child: Center(
                      child: Text(
                    'You have reached the end of content',
                    style: TextStyle(color: Colors.grey),
                  )),
                )
              ],
            ),
          ]),
        )
      ],
    );
  }

  _buildStory() {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          const CirculeUser(isUser: false),
          ...List.generate(
            context.watch<HomeProvider>().postings?.length ?? 0,
            (index) => CirculeUser(
              name: context.read<HomeProvider>().postings![index].username!,
              onTap: () {
                context.read<StoryProvider>().setPosting(
                    post: context.read<HomeProvider>().postings![index]);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StoryScreen()));
              },
            ),
          )
        ],
      ),
    );
  }

  _buildPostings() {
    if (context.watch<HomeProvider>().postings == null) {
      return [const Center(child: CircularProgressIndicator())];
    } else if (context.watch<HomeProvider>().postings!.isEmpty) {
      return [
        SizedBox(
          height: MediaQuery.sizeOf(context).height * .5,
          width: double.infinity,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.local_cafe_outlined,
                color: Colors.black38,
                size: 50,
              ),
              Text('Be the first to update progress ')
            ],
          ),
        )
      ];
    } else {
      return List.generate(
        context.watch<HomeProvider>().postings!.length,
        (index) => UserPosting(
            onTap: () {
              Navigator.push(
                  context,
                  CustomPageTransition.slideToPage(
                      page: UserInfoPage(
                        name: context
                            .read<HomeProvider>()
                            .postings![index]
                            .username!,
                        userId: context
                            .read<HomeProvider>()
                            .postings![index]
                            .userId!,
                      ),
                      slide: SlideFrom.right));
            },
            onSelected: (value) {
              if (value == 0) {
                Navigator.push(
                  context,
                  CustomPageTransition.slideToPage(
                      page: UserInfoPage(
                        name: context
                            .read<HomeProvider>()
                            .postings![index]
                            .username!,
                        userId: context
                            .read<HomeProvider>()
                            .postings![index]
                            .userId!,
                      ),
                      slide: SlideFrom.right),
                );
              } else if (value == 1) {
                context.read<ManagePostProvider>().setPosting(
                    post: context.read<HomeProvider>().postings![index]);
                Navigator.push(
                  context,
                  CustomPageTransition.slideToPage(
                      page: const ManagePostPage(), slide: SlideFrom.bottom),
                );
              }
            },
            name: context.watch<HomeProvider>().postings![index].username!,
            todayPlans:
                context.watch<HomeProvider>().postings![index].todayPlans!,
            blocker: context.watch<HomeProvider>().postings![index].blocker!),
      );
    }
  }
}