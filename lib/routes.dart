import 'package:flutter/material.dart';
import 'package:emrals/screens/home/home_screen.dart';
import 'package:emrals/screens/login/login_screen.dart';
import 'package:emrals/screens/settings.dart';
import 'package:emrals/screens/camera.dart';
import 'package:emrals/screens/report_detail.dart';

final routes = {
  '/login':        (BuildContext context) => new LoginScreen(),
  '/home':         (BuildContext context) => new MyHomePage(),
  '/settings':     (BuildContext context) => new Settingg(),
  //'/report':       (BuildContext context) => new ReportDetail(),
  '/camera':       (BuildContext context) => new CameraApp(),
  '/' :            (BuildContext context) => new LoginScreen(),
};