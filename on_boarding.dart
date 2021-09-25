import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoarding extends StatefulWidget {
  final List<Screen> pages;
  final TxtStyle titleStyle;
  final TxtStyle bodyStyle;
  final TxtStyle startTextStyle;
  final Color startButtonColor;
  final bool pageIndicator;
  final bool onDotTap;
  final Function(BuildContext) onStartTap;
  final Color? dotColor;
  final Color? activeDotColor;
  final Duration durationAnimation;
  final Curve curveAnimation;
  const OnBoarding({
    Key? key,
    required this.pages,
    required this.onStartTap,
    this.titleStyle = const TxtStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 28,
    ),
    this.bodyStyle = const TxtStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
    this.startTextStyle = const TxtStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
    this.pageIndicator = true,
    this.onDotTap = true,
    this.startButtonColor = Colors.blue,
    this.dotColor,
    this.activeDotColor,
    this.durationAnimation = const Duration(milliseconds: 250),
    this.curveAnimation = Curves.decelerate,
  }) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  PageController _pageController = PageController(
    initialPage: 0,
  );
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: getBottomNavigationBar(),
      body: getBody(size),
    );
  }

  Widget getBottomNavigationBar() {
    return _currentPage == widget.pages.length - 1
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: OutlinedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => widget.startButtonColor)),
                onPressed: () => widget.onStartTap(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    "Start",
                    style: TextStyle(
                      color: widget.startTextStyle.color ?? Colors.white,
                      fontSize: widget.startTextStyle.fontSize ?? 20,
                      fontWeight:
                          widget.startTextStyle.fontWeight ?? FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                )),
          )
        : SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15,
                bottom: 40,
                top: 40,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        _pageController.animateToPage(widget.pages.length - 1,
                            duration: widget.durationAnimation,
                            curve: Curves.easeIn);
                      },
                      child: Text("Skip",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: widget.bodyStyle.color,
                          ))),
                  Visibility(
                    visible: widget.pageIndicator,
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: widget.pages.length,
                      axisDirection: Axis.horizontal,
                      onDotClicked: (index) {
                        if (widget.onDotTap)
                          _pageController.animateToPage(
                            index,
                            duration: widget.durationAnimation,
                            curve: widget.curveAnimation,
                          );
                      },
                      effect: WormEffect(
                          dotWidth: 10,
                          dotHeight: 10,
                          dotColor: widget.dotColor ?? Colors.grey,
                          activeDotColor: widget.activeDotColor ?? Colors.blue),
                    ),
                  ),
                  InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        _pageController.animateToPage(
                          _currentPage + 1,
                          duration: widget.durationAnimation,
                          curve: widget.curveAnimation,
                        );
                      },
                      child: Text("Next",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: widget.startButtonColor,
                          ))),
                ],
              ),
            ),
          );
  }

  Widget getBody(Size size) {
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
      children: List.generate(
          widget.pages.length,
          (index) => screen(size, widget.pages[index].image,
              widget.pages[index].title, widget.pages[index].body)),
    );
  }

  Widget screen(Size size, String image, String title, String body) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: size.height / 5,
                ),
                SvgPicture.asset(
                  image,
                  width: size.width / 1.2,
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: widget.titleStyle.fontSize ?? 30,
                      fontWeight:
                          widget.titleStyle.fontWeight ?? FontWeight.bold,
                      color: widget.titleStyle.color ?? Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  body,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: widget.bodyStyle.fontSize ?? 20,
                    color: widget.titleStyle.color ?? Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Screen {
  final String image;
  final String title;
  final String body;

  Screen({required this.image, required this.title, required this.body});
}

class TxtStyle {
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? color;

  const TxtStyle({this.fontWeight, this.fontSize, this.color});
}
