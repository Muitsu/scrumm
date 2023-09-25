import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrumm/app_theme.dart';
import 'package:scrumm/screens/manager/add_post_page.dart';

import 'custom_page_transition.dart';

class CirculeUser extends StatelessWidget {
  final void Function()? onTap;
  final double height;
  final double width;
  final bool isUser;
  final bool userSmall;
  final String? name;
  const CirculeUser(
      {super.key,
      this.onTap,
      this.isUser = true,
      this.userSmall = false,
      this.name,
      this.height = 70,
      this.width = 70});
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: userSmall ? 0 : 8),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: isUser
                    ? onTap
                    : () {
                        Navigator.push(
                            context,
                            CustomPageTransition.slideToPage(
                                page: const AddPostPage(),
                                slide: SlideFrom.bottom));
                      },
                customBorder: const CircleBorder(),
                child: Container(
                  height: height,
                  width: width,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: context.watch<AppThemeProvider>().isDarkMode
                          ? Colors.black.withOpacity(0.2)
                          : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue, width: 1.8)),
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isUser
                            ? (context.watch<AppThemeProvider>().isDarkMode
                                ? const Color(0xFF1e2124)
                                : Colors.grey.withOpacity(0.4))
                            : Colors.blue),
                    child: isUser
                        ? Center(child: Text(shortenName(name!)))
                        : Icon(
                            Icons.add,
                            color: isUser ? Colors.black54 : Colors.white,
                          ),
                  ),
                ),
              ),
              SizedBox(width: userSmall ? 8 : 0),
              userSmall
                  ? SizedBox(
                      width: MediaQuery.sizeOf(context).width < 850
                          ? MediaQuery.sizeOf(context).width * 0.55
                          : MediaQuery.sizeOf(context).width * 0.4,
                      child: Text(
                        name ?? '-',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          ),
          SizedBox(height: userSmall ? 0 : 5),
          userSmall
              ? const SizedBox.shrink()
              : SizedBox(
                  width: width,
                  child: Text(
                    isUser ? name ?? '-' : 'Add Scrum',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                  ))
        ],
      ),
    );
  }
}
