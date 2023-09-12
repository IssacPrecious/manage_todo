import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:manage_todo/constants.dart';
import 'package:manage_todo/login_screen.dart';
import 'package:manage_todo/main.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    //final isFirstTime = ref.watch(sharedPreferenceProvider).getBool(isWelcomeScreenShown) ?? false;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/welcome.svg'),
              const SizedBox(height: 16),
              Text(
                'Manage your tasks',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 16),
              Text(
                'You can easily manage all of your daily tasks here for free.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 64),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  ),
                  onPressed: () async {
                    sharedPreferences.setBool(isWelcomeScreenShown, true);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return const LoginScreen();
                      },
                    ));
                  },
                  child: Text(
                    'GET STARTED',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
