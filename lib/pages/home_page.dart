import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talktrail/services/alert_services.dart';
import 'package:talktrail/services/auth_service.dart';
import 'package:talktrail/services/navigation_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetIt _getIt = GetIt.instance;

  late AuthService _authService;
  late NavigationService _navigationService;
  late AlertService _alertService;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Text("Messages"),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 13.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () async {
                    bool result = await _authService.logout();

                    if (result) {
                      _alertService.showToast(
                        text: "Logged out Successfully!",
                        icon: Icons.verified,
                      );
                      _navigationService.pushReplacementNamed('/login');
                    }
                  },
                  icon: Icon(
                    Icons.logout_outlined,
                  ),
                  label: Text("LOGOUT"),
                )
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: Text("Home Page!"),
      ),
    );
  }
}
