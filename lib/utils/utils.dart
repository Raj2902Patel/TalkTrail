import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:talktrail/firebase_options.dart';
import 'package:talktrail/services/alert_services.dart';
import 'package:talktrail/services/auth_service.dart';
import 'package:talktrail/services/media_services.dart';
import 'package:talktrail/services/navigation_services.dart';

Future<void> setupFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> registerServices() async {
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<AuthService>(
    AuthService(),
  );
  getIt.registerSingleton<NavigationService>(
    NavigationService(),
  );
  getIt.registerSingleton<AlertService>(
    AlertService(),
  );
  getIt.registerSingleton<MediaService>(
    MediaService(),
  );
}
