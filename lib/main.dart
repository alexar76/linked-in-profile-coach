import 'package:flutter/material.dart';

import 'app.dart';
import 'platform_db.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureSqliteForPlatform();
  runApp(const LinkedInProfileCoachApp());
}
