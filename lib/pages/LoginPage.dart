import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart';
import 'package:mediaquery_sizer/mediaquery_sizer.dart';
import 'package:sahayak/pages/Dashboard.dart';
import 'package:sahayak/pages/OtpVerify.dart';
import 'package:sahayak/pages/SignUpPage.dart';
import 'package:sahayak/utils.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

var boxLogin = Hive.box("stats");

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  bool showProg = false;

  Future loginToBackend(phoneno) async {
    var details = {
      "no": phoneno,
    };

    final response = await post(
      Uri.parse('https://ccs-internal-hack-1.pushanagrawal.repl.co/otp'),
      headers: {"Content-Type": "application/json"},
      // encoding: Encoding.getByName('utf-8'),
      body: jsonEncode(details),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // var d = jsonDecode(response.body);
      showSnackBar("OTP Success", "", ContentType.success, context);

      print(response.body);
      boxLogin.put("phoneNo", phoneno);
      changePageTo(context, OtpVerify());
    } else {
      if (response.statusCode == 404) {
        showSnackBar("Account Not Exists", "Please Create Your Account",
            ContentType.failure, context);
        changePageTo(context, SignUpPage());
        return;
      }

      // If the server did not return a 200 OK response,
      // then throw an exception.
      // var d = jsonDecode(response.body);
      showSnackBar(
          "Login Error", "Please Check The Form", ContentType.failure, context);
      print(response.body);
    }

    setState(() {
      showProg = false;
    });
  }

  Widget loginButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.green[800]),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: () {
          // Validate returns true if the form is valid, or false otherwise.
          if (_formKey.currentState!.validate()) {
            setState(() {
              showProg = true;
            });
            // ... Login To your Home Page
            loginToBackend(phoneController.value.text);
          }
        },
        child: Row(
          children: [
            showProg
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  )
                : SizedBox(),
            const Text('Get OTP'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 3.h(context),
            ),
            getSwitcher(context, 0.1),
            SizedBox(
              height: 3.h(context),
            ),
            getLogo(context),
            SizedBox(
              height: 4.h(context),
            ),
            Center(
                child: Text(
              "Login to your account",
              style: GoogleFonts.poppins(
                  fontSize: 18.sp(context), fontWeight: FontWeight.w600),
            )),
            SizedBox(
              height: 5.h(context),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    /// username or Gmail
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        hintText: 'Phone No',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      controller: phoneController,
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone no';
                        } else if (value.length < 10) {
                          return 'at least enter 10 characters';
                        }
                        return null;
                      },
                    ),

                    SizedBox(
                      height: 5.h(context),
                    ),

                    /// Login Button
                    loginButton(),
                    SizedBox(
                      height: 3.h(context),
                    ),

                    Center(
                        child: Text(
                      "Don't Have an account,",
                      style: GoogleFonts.poppins(fontSize: 15.sp(context)),
                    )),
                    Center(
                        child: GestureDetector(
                      onTap: () =>
                          changePageTo(context, SignUpPage(), replace: true),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "SignUp",
                          style: GoogleFonts.poppins(
                              fontSize: 16.sp(context),
                              color: Colors.blue[600]),
                        ),
                      ),
                    )),

                    /// Navigate To Login Screen
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
