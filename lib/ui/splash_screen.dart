import 'package:flutter/material.dart';
import 'package:pokedex_app/common/styles.dart';

import 'home/home_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  bool showLogo = false;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1500)).then((value) {
      setState(() => showLogo = true);
      Future.delayed(const Duration(seconds: 2))
          .then((value) => Navigator.pushNamed(context, HomePage.routeName));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kBlackColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              // left: showLogo ? 65 : 100,
              left: showLogo ? width * 0.21 : width * 0.5 - 50,
              duration: const Duration(milliseconds: 500),
              child: Text(
                '💀',
                style: whiteTextStyle.copyWith(
                  fontSize: 48,
                  fontWeight: semiBold,
                ),
              ),
            ),
            Positioned(
              // right: 55,
              left: width * 0.5 - 40,
              child: AnimatedOpacity(
                  curve: Curves.easeInOut,
                  opacity: showLogo ? 1 : 0,
                  duration: const Duration(milliseconds: 1350),
                  child: Text(
                    'Pokedex',
                    style: whiteTextStyle.copyWith(
                        fontSize: 28, fontWeight: semiBold),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
