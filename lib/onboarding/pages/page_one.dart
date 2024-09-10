import 'package:flutter/material.dart';

class PageOne extends StatelessWidget {
  const PageOne({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          child: Center(
            child: Image.asset('assets/vecteezy_rotate-your-phone.gif'),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          'Phone Angle',
          style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 18
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          'Keep your device horizontal at 0. \nGyrometer will guide you to find the right angle for best results',
          style: TextStyle(
              color: Colors.white54
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
