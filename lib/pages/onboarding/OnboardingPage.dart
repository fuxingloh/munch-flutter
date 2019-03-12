import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();

  static Future<T> push<T extends Object>(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => OnboardingPage(),
        settings: const RouteSettings(name: '/onboarding'),
      ),
    );
  }
}

class _OnboardingPageState extends State<OnboardingPage> {
  PageController controller;

  @override
  void initState() {
    super.initState();
    this.controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: controller,
        itemBuilder: (c, i) {
          switch (i) {
            case 0:
              return _OnboardingPage1();
            case 1:
              return _OnboardingPage2();
          }
          return null;
        },
        itemCount: 2,
      ),
    );
  }
}

class _OnboardingPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}

class _OnboardingPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
