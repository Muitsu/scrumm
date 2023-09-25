import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scrumm/app_theme.dart';
import 'package:scrumm/widgets/circle_user.dart';

class UserPosting extends StatelessWidget {
  final String name;
  final String todayPlans;
  final String blocker;
  final void Function()? onTap;
  final void Function(int)? onSelected;
  final bool hideTop;
  final bool showCopy;
  const UserPosting({
    super.key,
    required this.name,
    required this.todayPlans,
    required this.blocker,
    this.hideTop = false,
    this.showCopy = false,
    this.onTap,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: context.watch<AppThemeProvider>().isDarkMode
                ? const Color(0xFF1e2124)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: hideTop ? 0 : 10),
              Visibility(
                visible: !hideTop,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: [
                      CirculeUser(
                        userSmall: true,
                        height: 40,
                        width: 40,
                        name: name,
                      ),
                      const Spacer(),
                      PopupMenuButton(
                          itemBuilder: (context) {
                            return [
                              const PopupMenuItem<int>(
                                value: 0,
                                child: Text("View Profile"),
                              ),
                              const PopupMenuItem<int>(
                                value: 1,
                                child: Text("Edit Scrum"),
                              ),
                            ];
                          },
                          onSelected: onSelected),
                    ],
                  ),
                ),
              ),
              hideTop
                  ? const SizedBox(height: 10)
                  : const Divider(
                      indent: 5,
                      endIndent: 5,
                    ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            "What is your plan today ?",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.8,
                              child: Text(todayPlans)),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: showCopy,
                      child: IconButton(
                          onPressed: () async {
                            await Clipboard.setData(
                                ClipboardData(text: todayPlans));
                          },
                          icon: const Icon(
                            Icons.copy,
                            color: Colors.grey,
                          )),
                    )
                  ],
                ),
              ),
              const Divider(
                indent: 30,
                endIndent: 16,
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Anything blocking your progress ?",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.8,
                              child: Text(blocker)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}
