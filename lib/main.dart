import 'package:arohana_educational_society/mytransitions.dart';
import 'package:arohana_educational_society/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main()  {
  WidgetsFlutterBinding.ensureInitialized();
  initHiveForFlutter();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
