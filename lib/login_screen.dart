import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manage_todo/constants.dart';
import 'package:manage_todo/dashboard_screen.dart';
import 'package:manage_todo/main.dart';
import 'package:pinput/pinput.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

TextEditingController mobileNumberController = TextEditingController();

TextEditingController pinController = TextEditingController();

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: primaryColor),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  bool showOTP = false;
  bool isInputEnabled = true;
  String labelText = "GET OTP";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/login.svg'),
                const SizedBox(height: 16),
                Text(
                  'Login',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Mobile Number"),
                    SizedBox(height: 8),
                    TextFormField(
                      enabled: isInputEnabled,
                      controller: mobileNumberController,
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: primaryColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: primaryColor),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Visibility(
                  visible: showOTP,
                  child: Pinput(
                    controller: pinController,
                    androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
                    listenForMultipleSmsOnAndroid: true,
                    defaultPinTheme: defaultPinTheme,
                    separatorBuilder: (index) => const SizedBox(width: 8),
                    onCompleted: (pin) {},
                  ),
                ),
                const SizedBox(height: 64),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    ),
                    onPressed: () async {
                      String mobileNumber = mobileNumberController.text;
                      if (mobileNumber.length == 10) {
                        setState(() {
                          showOTP = true;
                          isInputEnabled = false;
                          labelText = "LOGIN";
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Enter a valid Mobile Number'),
                        ));
                      }

                      if (showOTP) {
                        String otp = pinController.text;
                        if (otp.length == 4) {
                          sharedPreferences.setBool(isLoggedIn, true);

                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return const DashboardScreen();
                            },
                          ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Enter a valid OTP'),
                          ));
                        }
                      }
                    },
                    child: Text(
                      labelText,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
