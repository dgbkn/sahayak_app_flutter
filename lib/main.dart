import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
import 'package:sahayak/pages/Dashboard.dart';
import 'package:sahayak/pages/Hospitals.dart';
import 'package:sahayak/pages/LoginPage.dart';
import 'package:sahayak/pages/OtpVerify.dart';
import 'package:sahayak/pages/SignUpPage.dart';
import 'package:sahayak/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mediaquery_sizer/mediaquery_sizer.dart';
import 'dart:async';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('stats');
  runApp(EasyDynamicThemeWidget(child: const MyApp()));
}

var box = Hive.box('stats');

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sahayak APP',
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(backgroundColor: Colors.green[800])
      ),
      darkTheme: ThemeData.dark(),
      themeMode: EasyDynamicTheme.of(context).themeMode,
      home: SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void loadNextPage() {
    Timer(const Duration(seconds: 3), () {
      changePageTo(context, isLoggedin() ? Dashboard() :LoginPage(),replace: true);
    });
  }

  void initState() {
    super.initState();
    loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(children: [
            SizedBox(
              height: 3.h(context),
            ),
            getSwitcher(context,0.2),
            SizedBox(
              height: 3.h(context),
            ),
            getLogo(context),
            SizedBox(
              height: 5.h(context),
            ),
            Lottie.asset(
              'assets/heal_anim.json',
              height: 40.h(context),
            ),
            Center(
                child: Text(
              "Instant help in your hand with",
              style: GoogleFonts.poppins(fontSize: 18.sp(context)),
            )),
            Center(
                child: Text(
              "Sahayak App",
              style: GoogleFonts.poppins(
                  fontSize: 20.sp(context), fontWeight: FontWeight.w600),
            )),
          ]),
        ),
      ),
    );
  }
}
