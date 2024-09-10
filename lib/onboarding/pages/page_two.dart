import 'package:flutter/material.dart';

class PageTwo extends StatelessWidget {
  const PageTwo({
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
          'Guiding Placeholders',
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
          'Can get help of placeholders to get your takes in order. \nor not and bring it in from your gallery',
          style: TextStyle(
              color: Colors.white54
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
