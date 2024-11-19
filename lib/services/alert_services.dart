import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talktrail/services/navigation_services.dart';

class AlertService {
  final GetIt _getIt = GetIt.instance;

  late NavigationService _navigationService;

  AlertService() {
    _navigationService = _getIt.get<NavigationService>();
  }

  void showToast({required String text, IconData icon = Icons.info}) {
    try {
      DelightToastBar(
        autoDismiss: true,
        position: DelightSnackbarPosition.top,
        builder: (context) {
          return ToastCard(
            leading: Icon(icon, size: 30),
            title: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18.0,
              ),
            ),
          );
        },
      ).show(_navigationService.navigatorKey!.currentContext!);
    } catch (error) {
      print(error);
    }
  }
}
