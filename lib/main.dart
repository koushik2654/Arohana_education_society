import 'package:arohana_educational_society/mytransitions.dart';
import 'package:arohana_educational_society/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  static SharedPreferences get prefs => _prefs;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initHiveForFlutter();
  await SharedPreferencesService.init();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: MyTranslations(),
      locale: Locale('en'),
      fallbackLocale: Locale('en'),
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: loginpage()
    );
  }
}
