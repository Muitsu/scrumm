import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrumm/app_theme.dart';
import 'package:scrumm/screens/story/story_provider.dart';
import 'package:scrumm/widgets/responsive_layout.dart';
import 'package:scrumm/widgets/circle_user.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  StoryScreenState createState() => StoryScreenState();
}

class StoryScreenState extends State<StoryScreen>
    with TickerProviderStateMixin {
  int timerSeconds = 6;
  bool isPaused = false;
  late Timer _timer;
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late StoryProvider storyProvider;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: timerSeconds),
    );

    _progressAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController)
          ..addListener(() {
            setState(() {});
          });

    _animationController.forward();
    _startTimer();
    storyProvider = Provider.of(context, listen: false);
  }

  _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timerSeconds--;
      if (timerSeconds == 0) {
        _timer.cancel();
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer.cancel();
    super.dispose();
  }

  _startAnimate() {
    setState(() {
      isPaused = false;
      _animationController.forward();
      _startTimer();
    });
  }

  _pausedAnimate() {
    setState(() {
      _timer.cancel();
      isPaused = true;
      _animationController.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _pausedAnimate();
      },
      onTapUp: (_) {
        _startAnimate();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: LinearProgressIndicator(
                    value: _progressAnimation.value,
                    backgroundColor: Colors.grey,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back)),
                  CirculeUser(
                    height: 40,
                    width: 40,
                    userSmall: true,
                    name: storyProvider.posting?.username,
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                        onPressed: () =>
                            isPaused ? _startAnimate() : _pausedAnimate(),
                        icon: Icon(isPaused ? Icons.play_arrow : Icons.pause)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ResponsiveLayout(
                    mobileView: _storyContent(),
                    tabletView: _backgroundStory(
                      Row(
                        children: [
                          SizedBox(
                              width: MediaQuery.sizeOf(context).width * .2),
                          Expanded(flex: 2, child: _storyContent()),
                          SizedBox(
                              width: MediaQuery.sizeOf(context).width * .2),
                        ],
                      ),
                    ),
                    webView: _backgroundStory(
                      Row(
                        children: [
                          SizedBox(
                              width: MediaQuery.sizeOf(context).width * .3),
                          Expanded(flex: 2, child: _storyContent()),
                          SizedBox(
                              width: MediaQuery.sizeOf(context).width * .3),
                        ],
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  _backgroundStory(Widget content) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: context.watch<AppThemeProvider>().isDarkMode
                ? const Color(0xFF1e2124)
                : Colors.grey.shade300,
          ),
        ),
        content
      ],
    );
  }

  _storyContent() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'What`s your plan\ntoday ?',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87),
            ),
            const SizedBox(height: 20),
            Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12))),
                child: Text(
                  storyProvider.posting?.todayPlans! ?? 'Null Data',
                  style: const TextStyle(color: Colors.black87),
                )),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Anything blocking your progress ?',
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87),
              ),
            ),
            const SizedBox(height: 20),
            Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12))),
                child: Text(
                  storyProvider.posting?.blocker! ?? 'Null Data',
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Colors.black87),
                )),
          ],
        ),
      ),
    );
  }
}
