// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

moveToNext(BuildContext context, Widget pageName) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => pageName,
    ),
  );
}

moveReplacePage(BuildContext context, Widget pageName) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => pageName,
    ),
    (route) => false,
  );
}

toast(msg, {Color? backgroundColor}) {
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: backgroundColor ?? AppColors.themeColor,
  );
}

Future<void> launchURL(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}

double commonHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double commonWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

String getGreeting() {
  final hour = DateTime.now().hour;

  if (hour < 12) {
    return 'Good Morning!';
  } else if (hour < 17) {
    return 'Good Afternoon!';
  } else {
    return 'Good Evening!';
  }
}

String formatTime(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  String formattedTime = DateFormat('hh:mm').format(dateTime.toLocal());
  return formattedTime;
}

Future<void> openMap(String latitude, String longitude) async {
  final Uri mapUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
  if (await canLaunchUrl(mapUrl)) {
    await launchUrl(mapUrl, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not open the map.';
  }
}

Future<File?> getImageFromGallery() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    return File(image.path);
  }
  return null;
}
