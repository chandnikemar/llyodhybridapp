import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ut_lloyd_web_app/service/api_service.dart';
import 'package:ut_lloyd_web_app/view/screen/main_navigation_screen.dart';
import 'package:ut_lloyd_web_app/view/screen/splash_screen.dart';
import 'package:ut_lloyd_web_app/view_model/home_dashboard_view_model.dart';
import 'package:ut_lloyd_web_app/view_model/login_view_model.dart';
import 'package:ut_lloyd_web_app/view_model/management_report_view_model.dart';
import 'package:ut_lloyd_web_app/view_model/ordermanagement_view_model.dart';
import 'package:ut_lloyd_web_app/view_model/reports_view_model.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // GlobalKey to access Navigator from anywhere
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardReportViewModel()),
        ChangeNotifierProvider(create: (_) => ReportsViewModel()),
        ChangeNotifierProvider(create: (_) => MGMReportsViewModel()),
        ChangeNotifierProvider(create: (_) => OrderManagementViewModel())

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: 'Login Page',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Poppins',
        ),
        initialRoute: '/',
        routes: {

          '/': (context) => SplashScreen(),
          '/home': (context) => MainNavigationScreen(),
        },
      ),
    );
  }
}
