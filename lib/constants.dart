import 'dart:io';
import 'package:fahis_studio/models/hatchback_body.dart';
import 'package:fahis_studio/models/minivan_body.dart';
import 'package:fahis_studio/models/sedan_body.dart';
import 'package:fahis_studio/models/suv_body.dart';
import 'package:flutter/material.dart';

class Constants {
  static Color primaryColor = Colors.orange;
  static Color secondaryColor = Colors.orange;
  static Language lang = Language.en;
  static double sizeSm = 6;
  static double sizeMd = 8;
  static double sizeLg = 16;
  static double borderRadiusSm = 6;
  static double borderRadiusMd = 8;
  static double borderRadiusLg = 16;
  static List<String> backgrounds = [];
  static List<BodyType>? availableBodyType;
  static List<BodyType>? defaultAvailableBodyType = [
    SuvBody(),
    SedanBody(),
    HatchBackBody(),
    MiniVanBody(),
  ];
}

enum Language{
  en, ar
}

enum BodyTypes{
  suv , sedan , track , hatchback , van , bus , pickup , other
}

enum BodyParts{
  frontSide ,
  backSide ,
  leftSide ,
  rightSide ,
  frontLeft ,
  frontRight ,
  backLeft ,
  backRight ,
  backStorage ,
  dashboard ,
  engine ,
  driveConsole,
  frontRightDoor ,
  frontLeftDoor ,
  backRightDoor ,
  backLeftDoor ,
  frontRightTire ,
  frontLeftTire ,
  backRightTire ,
  backLeftTire ,
  exteriorVideo,
  other,
}

class BodyPart{

  BodyPart({
    required this.id,
    required this.name,
    required this.arName,
    required this.outlineBody,
    required this.bodyPart,
    this.cachedImage,
    this.image
  });

  num id;
  String name;
  String arName;
  BodyParts bodyPart;
  String outlineBody;
  String? image;
  File? cachedImage;

  String getOutline(){
    return outlineBody;
  }
}

class BodyType{
  File? video;
  BodyTypes bodyType = BodyTypes.other;
  String routeName = 'suv';
  String name = 'SUV';
  String arName = 'سي يو في';
  List<BodyPart> parts = [
    BodyPart(id: 1, name: 'front-side', arName: 'الواجهة الأمامية', outlineBody: 'front_side.png', bodyPart: BodyParts.frontSide),
    BodyPart(id: 2, name: 'front-left', arName: 'زاوية امام يسار', outlineBody: 'front_left_side.png', bodyPart: BodyParts.frontLeft),
    BodyPart(id: 3, name: 'left-side', arName: 'الواجهة اليسرى', outlineBody: 'left_side.png', bodyPart: BodyParts.leftSide),
    BodyPart(id: 4, name: 'back-left', arName: 'زاوية خلف يسار', outlineBody: 'back_left_side.png', bodyPart: BodyParts.backLeft),
    BodyPart(id: 5, name: 'back-side', arName: 'الواجهة الخلفية', outlineBody: 'back_side.png', bodyPart: BodyParts.backSide),
    BodyPart(id: 6, name: 'back-right', arName: 'زاوية خلف يمين', outlineBody: 'back_right_side.png', bodyPart: BodyParts.backRight),
    BodyPart(id: 7, name: 'right-side', arName: 'الواجهة اليمنى', outlineBody: 'right_side.png', bodyPart: BodyParts.rightSide),
    BodyPart(id: 8, name: 'front-right', arName: 'زاوية أمام يمين', outlineBody: 'front_right_side.png', bodyPart: BodyParts.frontRight),
    BodyPart(id: 9, name: '360-video', arName: 'فديو 360', outlineBody: 'front_right_side.png', bodyPart: BodyParts.exteriorVideo),
  ];
}