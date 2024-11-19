import 'package:flutter/cupertino.dart';
import 'package:talktrail/pages/home_page.dart';
import 'package:talktrail/pages/login_page.dart';
import 'package:talktrail/pages/register_page.dart';

class NavigationService {
  late GlobalKey<NavigatorState> _navigationKey;

  final Map<String, Widget Function(BuildContext)> _routes = {
    '/login': (context) => LoginPage(),
    '/register': (context) => RegisterPage(),
    '/home': (context) => HomePage(),
  };

  GlobalKey<NavigatorState>? get navigatorKey {
    return _navigationKey;
  }

  Map<String, Widget Function(BuildContext)> get routes {
    return _routes;
  }

  NavigationService() {
    _navigationKey = GlobalKey<NavigatorState>();
  }

  void pushNamed(String routeName) {
    _navigationKey.currentState?.pushNamed(routeName);
  }

  void pushReplacementNamed(String routeName) {
    _navigationKey.currentState?.pushReplacementNamed(routeName);
  }

  void goBack() {
    _navigationKey.currentState?.pop();
  }
}
