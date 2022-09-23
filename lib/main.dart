import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schloop/pages/create_user_page/create_user_page.dart';
import 'package:schloop/pages/home.dart';
import 'package:schloop/pages/search_user_page/org_member_list.dart';
import 'package:schloop/pages/search_user_page/search_user_page.dart';
import 'package:schloop/pages/settings.dart';
import 'package:schloop/services/config.dart';
import 'package:schloop/services/github/api_client.dart';
import 'package:schloop/stores/github_store.dart';
import 'package:schloop/stores/user_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GitHub.init();
  await Config.init();

  runApp(MultiProvider(providers: <ChangeNotifierProvider<dynamic>>[
    ChangeNotifierProvider<UserStore>(create: (_) => UserStore()),
    ChangeNotifierProvider<GitHubStore>(create: (_) => GitHubStore()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'schloop',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: <String, Widget Function(BuildContext)>{
          '/': (_) => HomePage(),
          '/user/search': (_) => SearchUserPage(),
          '/user/create': (_) => const CreateUserPage(),
          '/github/org/members': (_) => GitHubOrganizationMemberList(),
          '/settings': (_) => SettingsPage()
        });
  }
}
