import 'package:flutter/material.dart';
import 'package:scrumm/app_theme.dart';
import 'package:scrumm/screens/home/home_provider.dart';
import 'package:scrumm/screens/home/home_page.dart';
import 'package:scrumm/screens/manager/manage_post_provider.dart';
import 'package:scrumm/screens/member/member_provider.dart';
import 'package:scrumm/screens/story/story_provider.dart';
import 'package:scrumm/screens/user_info/user_info_provider.dart';
import 'package:scrumm/screens/scrum_activities/scrum_activities_provider.dart';
import 'gsheets/gsheets_api.dart';
import 'gsheets/gsheets_constant.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GsheetsAPI.init(spreadsheetId: GsheetsConstants.spreadsheetId);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: ((context) => HomeProvider())),
    ChangeNotifierProvider(create: ((context) => UserInfoProvider())),
    ChangeNotifierProvider(create: ((context) => ManagePostProvider())),
    ChangeNotifierProvider(create: ((context) => StoryProvider())),
    ChangeNotifierProvider(create: ((context) => MemberProvider())),
    ChangeNotifierProvider(create: ((context) => ScrumActivitiesProvider())),
    ChangeNotifierProvider(create: ((context) => AppThemeProvider())),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scrumm',
      debugShowCheckedModeBanner: false,
      themeMode: context.watch<AppThemeProvider>().themeMode,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      home: const MyHomePage(),
    );
  }
}
