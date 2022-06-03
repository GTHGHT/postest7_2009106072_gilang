import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/constants.dart';
import 'main_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late AnimationController _imageController;
  late Animation<Offset> _imageAnimation;
  late AnimationController _textController;
  late Animation<Offset> _textAnimation;
  late AnimationController _buttonController;
  late Animation<Offset> _buttonAnimation;

  @override
  void initState() {
    _imageController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _imageAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(_imageController);
    _textController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _textAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(_textController);
    _buttonController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _buttonAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(_buttonController);
    Timer(
      const Duration(milliseconds: 200),
      () => _imageController.forward(from: 0).then(
            (value) => _textController.forward(from: 0).then(
                  (value) => _buttonController.forward(from: 0),
                ),
          ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _imageController.dispose();
    _textController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FadeSlideTransition(
                fadeAnimation: _imageController,
                slideAnimation: _imageAnimation,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset(
                          kWeatherImageList[index % kWeatherImageList.length],
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : null,
                          fit: BoxFit.fitHeight,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              FadeSlideTransition(
                fadeAnimation: _textController,
                slideAnimation: _textAnimation,
                child: Column(
                  children: const [
                    Text(
                      "Discover the Weather\n"
                      "In Your City",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Lato",
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Find out what can be waiting for you\n"
                      "on the street with a few taps",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 7,
              ),
              FadeSlideTransition(
                fadeAnimation: _buttonController,
                slideAnimation: _buttonAnimation,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => MainPage(),
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(
                      vertical: 25,
                      horizontal: 10,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6CC1F6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "Get Started",
                      style: kLandingButtonTextStyle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FadeSlideTransition extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final Widget child;

  const FadeSlideTransition({
    Key? key,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: child,
      ),
    );
  }
}