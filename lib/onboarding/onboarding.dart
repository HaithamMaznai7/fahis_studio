import 'package:camera/camera.dart';
import 'package:fahis_studio/constants.dart';
import 'package:fahis_studio/fahis_studio/fahis_studio.dart';
import 'package:fahis_studio/models/suv_body.dart';
import 'package:fahis_studio/onboarding/pages/page_four.dart';
import 'package:fahis_studio/onboarding/pages/page_one.dart';
import 'package:fahis_studio/onboarding/pages/page_three.dart';
import 'package:fahis_studio/onboarding/pages/page_two.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({required this.cameras});

  final List<CameraDescription> cameras;
  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final _pageController = PageController(initialPage: 0);
  int currentPageIndex = 0;
  bool doNotShowAgain = false ;

  BodyType selectedBodyType = SuvBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _updatePageIndicator,
            children: [
              const PageOne(),
              const PageTwo(),
              PageThree(
                initBodyType: selectedBodyType,
                onChange: (BodyType bodyType) => setState(() {
                  selectedBodyType = bodyType;
                })
              ),
              const PageFour(),
            ],
          ),

          const CloseButton(),

          SkipButton(currentPageIndex: currentPageIndex,),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(
                bottom: 30,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .3,
                    child: Row(
                      children: [
                        Checkbox(
                            value: doNotShowAgain,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            checkColor: Colors.black54,
                            fillColor: WidgetStateProperty.resolveWith((states) {
                              if(states.contains(WidgetState.selected)){
                                return Colors.orange;
                              }else{
                                return Colors.transparent;
                              }
                            }),
                            onChanged: _willShowAgainChange
                        ),
                        Text('Do not show again',style:
                          TextStyle(
                            color: Colors.white70
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .3,
                    child: Center(
                      heightFactor: 0,
                      child: SmoothPageIndicator(
                        count: 4,
                        controller: _pageController,
                        onDotClicked: _dotNavigatorClick,
                        effect: WormEffect(activeDotColor: Colors.orange , dotHeight: 6, dotWidth: 12, type: WormType.thin),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        currentPageIndex > 0
                        ? InkWell(
                          onTap: () => setState(() {
                            _pageController.previousPage(duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                          }),
                          child: Container(
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(40),
                                    bottomLeft: Radius.circular(40)
                                ),
                                border: Border.all(
                                    color: Colors.white70.withOpacity(.1),
                                    width: 1
                                ),
                                color: Colors.white70.withOpacity(.2)
                            ),
                            child: Center(child: Text('Previous', style: TextStyle(
                                color: Colors.white70
                            ),)),
                          ),
                        )
                        : SizedBox(),
                        const SizedBox(width: 5,),
                        InkWell(
                          onTap: () {
                            if(currentPageIndex != 3){
                              setState(() {
                                _pageController.nextPage(
                                    duration:
                                        const Duration(milliseconds: 200),
                                    curve: Curves.easeIn);
                              });
                            }else{
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => FahisStudio(cameras: widget.cameras, bodyType: selectedBodyType))
                              );
                            }
                          },
                          child: Container(
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(40),
                                  bottomRight: Radius.circular(40)
                                ),
                                border: Border.all(
                                    color: Colors.orange.withOpacity(.4),
                                    width: 1
                                ),
                                color: Colors.orange
                            ),
                            child: Center(child: Text('Next', style: TextStyle(
                                color: Colors.white70
                            ),)),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }

  void _updatePageIndicator(index) => setState(() {
    currentPageIndex = index;
  });

  void _dotNavigatorClick(int index) {
    setState(() {
      _pageController.animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
    });
  }

  void _willShowAgainChange(bool? val) {
    setState(() {
      doNotShowAgain = val ?? false;
    });
  }
}

class CloseButton extends StatelessWidget {
  const CloseButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 30,
          left: MediaQuery.of(context).size.width * .05
        ),
        child: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: 30,
          )
        )
      ),
    );
  }
}

class SkipButton extends StatelessWidget {
  const SkipButton({
    super.key,
    this.currentPageIndex = 0
  });
  final int currentPageIndex;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: InkWell(
        onTap: (){},
        child: Container(
          margin: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * .05,
              top: 30
          ),
          width: 100,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: Colors.orange.withOpacity(.4),
              width: 1
            ),
            color: Colors.orange.withOpacity(.2)
          ),
          child: Center(
            child: Text('Skip (${currentPageIndex + 1}/4)',
              style: const TextStyle(
                color: Colors.white70
              ),
            )
          ),
        ),
      ),
    );
  }
}