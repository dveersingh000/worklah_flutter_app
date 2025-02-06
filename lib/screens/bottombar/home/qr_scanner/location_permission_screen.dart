import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

  Future<void> requestPermission(BuildContext context) async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      Navigator.pop(context, true);  // Return `true` if permission granted
    } else {
      Navigator.pop(context, false); // Return `false` if denied
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Enable Location"),
      content: const Text("To continue, your device will need to use Location Accuracy."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("No thanks"),
        ),
        TextButton(
          onPressed: () => requestPermission(context),
          child: const Text("Turn on"),
        ),
      ],
    );
  }
}
