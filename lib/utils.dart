import 'dart:io';
import 'dart:math';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:day_night_themed_switch/day_night_themed_switch.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mediaquery_sizer/mediaquery_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

var box = Hive.box('stats');

final _random = Random();
int randomGen(int min, int max) => min + _random.nextInt(max - min);

double roundDouble(double value, int places) {
  num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

void changePageTo(BuildContext context, Widget toGo, {bool replace = false}) {
  if (replace) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => toGo,
        ));
  } else {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => toGo,
        ));
  }
}

Widget loaderCircle() {
  return const Padding(
    padding: EdgeInsets.only(top: 12.0),
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
}

PreferredSize getAppBar(String text) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(80.0),
    child: AppBar(
      centerTitle: true,
      elevation: 5,
      title: Text(text),
    ),
  );
}

Future<void> launchALink(link) async {
  var url = Uri.parse(link);
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Could not launch $url';
  }
}

bool checkDarkTheme(context) {
  return Theme.of(context).brightness == Brightness.dark;
}

Widget getSwitcher(context, scale) {
  return Flexible(
    child: FractionallySizedBox(
      heightFactor: scale,
      child: DayNightSwitch(
        value: Theme.of(context).brightness == Brightness.dark,
        onChanged: (value) {
          EasyDynamicTheme.of(context).changeTheme(dark: value);
        },
      ),
    ),
  );
}

Widget getLogo(context) {
  return Image.asset(
    checkDarkTheme(context) ? 'assets/logo_dark.png' : 'assets/logo_light.png',
    height: 12.h(context),
  );
}

bool isLoggedin() {
  var token = box.get('token');
  if (token == null || token == '') {
    return false;
  }
  return true;
}

void showSnackBar(title, message, ContentType type, context) {
  final snackBar = SnackBar(
    /// need to set following properties for best effect of awesome_snackbar_content
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      contentType: type,
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
