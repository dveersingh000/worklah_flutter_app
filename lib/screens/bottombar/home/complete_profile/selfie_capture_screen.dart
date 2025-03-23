import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:work_lah/screens/model/user_model.dart';
import 'package:work_lah/utility/shared_prefs.dart';

class SelfieCaptureScreen extends StatefulWidget {
  final Function(String) onSelfieCaptured;

  const SelfieCaptureScreen({Key? key, required this.onSelfieCaptured}) : super(key: key);

  @override
  _SelfieCaptureScreenState createState() => _SelfieCaptureScreenState();
}

class _SelfieCaptureScreenState extends State<SelfieCaptureScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isCapturing = false;
  bool _isFrontCamera = true;
  String? _capturedImagePath;

  @override
  void initState() {
    super.initState();
    _initializeCamera(isFront: true); // ✅ Open Front Camera by Default
  }

  /// ✅ Initialize Camera with front/back option
  Future<void> _initializeCamera({bool isFront = true}) async {
    _cameras = await availableCameras();
    int selectedCameraIndex = isFront ? _getFrontCameraIndex() : _getBackCameraIndex();

    _cameraController = CameraController(_cameras![selectedCameraIndex], ResolutionPreset.high);
    await _cameraController!.initialize();

    if (!mounted) return;
    setState(() {
      _isCameraInitialized = true;
    });
  }

  /// ✅ Get front camera index
  int _getFrontCameraIndex() {
    return _cameras!.indexWhere((camera) => camera.lensDirection == CameraLensDirection.front);
  }

  /// ✅ Get back camera index
  int _getBackCameraIndex() {
    return _cameras!.indexWhere((camera) => camera.lensDirection == CameraLensDirection.back);
  }

  /// ✅ Toggle Camera (Front/Back)
  void _switchCamera() {
    setState(() {
      _isCameraInitialized = false;
      _isFrontCamera = !_isFrontCamera;
    });
    _initializeCamera(isFront: _isFrontCamera);
  }

  /// ✅ Capture Selfie
Future<void> _captureSelfie() async {
  if (!_cameraController!.value.isInitialized || _isCapturing) return;

  setState(() {
    _isCapturing = true;
  });

  try {
    final XFile imageFile = await _cameraController!.takePicture();
    final String imagePath = await _saveImage(imageFile);

    setState(() {
      _capturedImagePath = imagePath;
    });

    // ✅ Upload selfie directly after capture
    await _uploadProfilePicture(File(imagePath));

  } catch (e) {
    print("Error capturing selfie: $e");
  } finally {
    setState(() {
      _isCapturing = false;
    });
  }
}

Future<void> _uploadProfilePicture(File imageFile) async {
  try {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("https://worklah.onrender.com/api/profile/upload-profile-picture"),
    );

    // ✅ Fetch authentication token
    String? token = await getLoginToken();
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not authenticated. Please login again.")),
      );
      return;
    }

    request.headers['Authorization'] = "Bearer $token";
    request.files.add(await http.MultipartFile.fromPath("profilePicture", imageFile.path));

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      var data = json.decode(responseData);
      String newProfilePictureUrl = data['imageUrl'];

      // ✅ Update userModel with new profile picture
      UserModel? updatedUser = await getUserData();
      if (updatedUser != null) {
        updatedUser = updatedUser.copyWith(profilePicture: newProfilePictureUrl);
        await saveUserData(updatedUser.toJson());
      }

      // ✅ Notify user & update UI
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile picture updated successfully!")),
      );

      // ✅ Update the UI with the new profile image
      widget.onSelfieCaptured(newProfilePictureUrl);
      Navigator.pop(context);

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload image.")),
      );
    }
  } catch (e) {
    print("Error uploading image: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("An error occurred while uploading.")),
    );
  }
}


  /// ✅ Save Image Locally
  Future<String> _saveImage(XFile imageFile) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String imagePath = '${directory.path}/selfie.jpg';
    final File file = File(imagePath);
    await file.writeAsBytes(await imageFile.readAsBytes());
    return imagePath;
  }

  /// ✅ Confirm Selfie
  void _confirmSelfie() {
    if (_capturedImagePath != null) {
      widget.onSelfieCaptured(_capturedImagePath!);
      Navigator.pop(context);
    }
  }

  /// ✅ Retake Selfie
  void _retakeSelfie() {
    setState(() {
      _capturedImagePath = null;
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ Background Color
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Take a Selfie", style: TextStyle(color: Colors.black, fontSize: 18.sp)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {}, // Add notification logic if needed
          )
        ],
      ),
      body: _isCameraInitialized
          ? Stack(
              alignment: Alignment.center,
              children: [
                _capturedImagePath == null
                    ? CameraPreview(_cameraController!)
                    : Image.file(File(_capturedImagePath!)),

                // ✅ Circular Overlay Guide
                Positioned(
                  top: 150.h,
                  child: Container(
                    width: 250.w,
                    height: 250.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.green, width: 2),
                    ),
                  ),
                ),

                // ✅ Instructions
                Positioned(
                  top: 80.h,
                  child: Column(
                    children: [
                      Text(
                        "Position your face within the circle",
                        style: TextStyle(color: Colors.blue, fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "Note: Remove any wearables from your face while taking a selfie",
                        style: TextStyle(color: Colors.black54, fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),

                // ✅ "No Face Detected" Error (if needed)
                if (_capturedImagePath == null)
                  Positioned(
                    top: 40.h,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.red,
                      child: Text(
                        "No face detected. Please try again.",
                        style: TextStyle(color: Colors.white, fontSize: 12.sp),
                      ),
                    ),
                  ),

                // ✅ Capture Controls
                Positioned(
                  bottom: 50.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ❌ Retake Button
                      if (_capturedImagePath != null)
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red, size: 40),
                          onPressed: _retakeSelfie,
                        ),

                      SizedBox(width: 50.w),

                      // 📸 Capture Button
                      GestureDetector(
                        onTap: _capturedImagePath == null ? _captureSelfie : _confirmSelfie,
                        child: Icon(
                          _capturedImagePath == null ? Icons.camera_alt : Icons.check_circle,
                          color: Colors.black,
                          size: 70,
                        ),
                      ),

                      SizedBox(width: 50.w),

                      // 🔄 Switch Camera
                      IconButton(
                        icon: Icon(Icons.flip_camera_android, color: Colors.black, size: 40),
                        onPressed: _switchCamera,
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
