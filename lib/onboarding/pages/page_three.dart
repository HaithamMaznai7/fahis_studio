import 'package:fahis_studio/constants.dart';
import 'package:fahis_studio/models/hatchback_body.dart';
import 'package:fahis_studio/models/minivan_body.dart';
import 'package:fahis_studio/models/sedan_body.dart';
import 'package:fahis_studio/models/suv_body.dart';
import 'package:flutter/material.dart';

class PageThree extends StatefulWidget {
  const PageThree({super.key, required this.initBodyType, required this.onChange});

  final BodyType initBodyType;
  final  Function(BodyType bodyType) onChange;

  @override
  State<PageThree> createState() => _PageThreeState();
}

class _PageThreeState extends State<PageThree> {
  List<BodyType> bodies = [
    SuvBody(),
    SedanBody(),
    HatchBackBody(),
    MiniVanBody()
  ];
  BodyType selectedBody = SuvBody();


  @override
  void initState() {
    super.initState();
    setState(() {
      selectedBody = widget.initBodyType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          child: Center(
            child: Image.asset('assets/outlines/suv/front_right_side.png'),
          ),
        ),
        const SizedBox(height: 5,),
        const Text('Car Type Selection :', style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold
        ),),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .05,),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...bodies.map((body) =>
                  InkWell(
                    onTap: () => _selectBody(body),
                    child: Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            Image.asset('assets/outlines/${body.routeName}/left_side.png', height: 70, color: body.bodyType == selectedBody.bodyType ? Colors.orange : Colors.white,),
                            // SizedBox(height: 5,),
                            Text(
                              body.name,
                              style: TextStyle(
                                  color: body.bodyType == selectedBody.bodyType ? Colors.orange : Colors.white
                              ),
                            )
                          ],
                        )
                    ),
                  )
              ),

            ],
          ),
        ),
        const SizedBox(height: 40,),
      ],
    );
  }

  void _selectBody(BodyType body) {
    setState(() {
      selectedBody = body;
    });
    widget.onChange(body);
  }
}