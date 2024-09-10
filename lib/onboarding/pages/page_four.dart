import 'package:flutter/material.dart';

class PageFour extends StatelessWidget {
  const PageFour({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 200,
          child: Center(
            child: Image.asset('assets/onboarding_4.png'),
          ),
        ),
        const SizedBox(height: 5,),
        const Text('For the most accurate and high-quality results, Please shoot the car \nin line with the rearview mirror.', style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold
        ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}