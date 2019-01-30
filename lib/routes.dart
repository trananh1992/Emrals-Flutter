import 'package:flutter/material.dart';
import 'package:emrals/screens/home/home_screen.dart';
import 'package:emrals/screens/login/login_screen.dart';
import 'package:emrals/screens/login/signup_screen.dart';
import 'package:emrals/screens/settings.dart';
import 'package:emrals/screens/camera.dart';

final routes = {
  '/login':        (BuildContext context) => new LoginScreen(),
  '/signup':        (BuildContext context) => new SignupScreen(),
  '/home':         (BuildContext context) => new MyHomePage(),
  '/settings':     (BuildContext context) => new Settingg(),
  //'/report':       (BuildContext context) => new ReportDetail(),
  '/camera':       (BuildContext context) => new CameraApp(),
  '/' :            (BuildContext context) => new LoginScreen(),
};