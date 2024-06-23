import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/constants/colors.dart';
import '../../utils/device/device_utility.dart';
import '../../utils/helpers/helper_functions.dart';
import '../../utils/http/http_client.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();

  bool _sendingRequest = false;

  @override
  Widget build(BuildContext context) {
    double width = MyDeviceUtils.getScreenWidth(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopLogo(),
            // Text("Login to continue"),
            SizedBox(height: 100),
            Padding(
              padding:
                  EdgeInsets.only(left: width * 0.075, right: width * 0.075),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter Your Details",
                    style: TextStyle().copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  SizedBox(height: 24),
                  Container(
                    height: 45,
                    width: width * 0.85,
                    child: TextField(
                      controller: _emailEditingController,
                      keyboardType: TextInputType.emailAddress,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9._%+-@]'))
                      ],
                      style: TextStyle().copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: MyColors.textWhite),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 13.0, 20.0, 0.0),
                        filled: true,
                        fillColor: MyColors.fadedPrimary,
                        hintText: "Email",
                        hintStyle: TextStyle().copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: MyColors.white60),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          // Border radius
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(1),
                            width: 0.7,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 45,
                    width: width * 0.85,
                    child: TextField(
                      controller: _passwordEditingController,
                      keyboardType: TextInputType.visiblePassword,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]')),
                      ],
                      style: TextStyle().copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: MyColors.textWhite),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 13.0, 20.0, 0.0),
                        filled: true,
                        fillColor: MyColors.fadedPrimary,
                        hintText: "Password",
                        hintStyle: TextStyle().copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: MyColors.white60),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          // Border radius
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(1),
                            width: 0.7,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 45,
                    width: width * 0.85,
                    child: Opacity(
                      opacity: _sendingRequest ? 0.5 : 1,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_sendingRequest) {
                              return;
                            }
                            String email = _emailEditingController.text;
                            String password = _passwordEditingController.text;
                            if (email.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Email is empty.")));
                              return;
                            }
                            if (password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Password is empty.")));
                              return;
                            }

                            setState(() {
                              _sendingRequest = true;
                            });

                            // Map<String, dynamic> response =
                            //     await MyHttpHelper.post('token/',
                            //         {'username': email, 'password': password});
                            // if (response['result'] == 'error') {
                            //   setState(() {
                            //     _sendingRequest = false;
                            //   });
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //       SnackBar(content: Text(response['message'])));
                            // } else if (response['result'] == 'success') {
                            setState(() {
                              _sendingRequest = false;
                            });

                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/home',
                              (route) => false,
                            );
                            // }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.textWhite,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  40.0), // Circular border radius
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.5),
                            elevation: 5.0,
                          ),
                          child: _sendingRequest
                              ? Container(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: MyColors.primary,
                                    strokeWidth: 3,
                                  ))
                              : Text(
                                  'Log In',
                                  style: TextStyle().copyWith(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.primary),
                                  textAlign: TextAlign.center,
                                )),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TopLogo extends StatelessWidget {
  const TopLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // double statusHeight = MyDeviceUtils.getStatusBarHeight();
    return Container(
        child: Padding(
            padding: EdgeInsets.only(top: 150),
            child: Image(
              image: AssetImage("assets/images/logo.png"),
              width: 100,
            )));
  }
}
