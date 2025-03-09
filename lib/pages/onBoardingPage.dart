import 'package:devstack/zoomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:devstack/Custom/button_widget.dart';
import 'package:lottie/lottie.dart';

class OnBoardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SafeArea(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: 'ADD TASKS\n',
              body:
                  'Designed to help you to plan your work and always be on schedules\n\n',
              image: LottieBuilder.asset('assets/task.json', height: 1000),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'PLAN YOUR WORK USING OUR CALENDAR\n',
              body: 'Never forget your wife'
                  "'"
                  's birthday again!\n Choose to view your daily, weekly or monthly tasks separately',
              image: LottieBuilder.asset(
                'assets/calendar.json',
                height: 1000,
              ),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'TIME YOUR WORK USING OUR FOCUS TIMER\n',
              body:
                  '"Give me six hours to chop down a tree and I will spend the first four sharpening the axe"'
                  '~'
                  'Abraham Lincoln',
              image: LottieBuilder.asset('assets/timer.json', height: 1000),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'GET REWARDS\n',
              body:
                  'On completion of tasks you are rewarded with coins which you can use to unlock new options and avatars',
              image: LottieBuilder.asset('assets/coin.json', height: 1000),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'YOU ARE READY TO GO',
              body: '',
              footer: ButtonWidget(
                text: 'Get Started',
                onClicked: () => goToHome(context),
              ),
              image: LottieBuilder.asset('assets/startup.json'),
              decoration: getPageDecoration(),
            ),
          ],
          done: Text('Start', style: TextStyle(fontWeight: FontWeight.w600)),
          onDone: () => goToHome(context),
          showSkipButton: true,
          skip: Text('Skip'),
          onSkip: () => goToHome(context),
          next: Text('Next'), //Icon(Icons.arrow_circle_right_sharp),
          dotsDecorator: getDotDecoration(),
          globalBackgroundColor: Theme.of(context).bottomAppBarColor,
          onChange: (index) => print('Page $index selected'),
          skipOrBackFlex: 0,
          nextFlex: 0,
          // isProgressTap: false,
          // isProgress: false,
          // showNextButton: false,
          // freeze: true,
          // animationDuration: 1000,
        ),
      );

  void goToHome(context) => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => zoomDrawer()),
      );

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 800));

  DotsDecorator getDotDecoration() => DotsDecorator(
        color: Color(0xFFBDBDBD),
        activeColor: Colors.orange,
        size: Size(10, 10),
        activeSize: Size(40, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      );

  PageDecoration getPageDecoration() => PageDecoration(
        titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontSize: 20),
        titlePadding: EdgeInsets.all(16).copyWith(bottom: 0),
        imagePadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        footerPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        pageColor: Colors.white,
      );
}
