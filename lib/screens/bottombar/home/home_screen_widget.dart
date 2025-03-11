// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/screens/bottombar/home/job_detail/job_details.dart';
import 'package:work_lah/screens/notification_screen.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/utility/style_inter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:work_lah/utility/image_path.dart';
import 'package:work_lah/utility/shared_prefs.dart';
import 'package:work_lah/screens/model/user_model.dart';
import 'package:work_lah/screens/bottombar/bottom_bar_screen.dart';
import 'package:work_lah/screens/login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';

// import 'package:work_lah/screens/bottombar/home/qr_scanner/scan_qr_screen.dart';

class TopBarWidget extends StatefulWidget {
  final String userName;
  String imgPath;

  TopBarWidget({super.key, required this.userName, required this.imgPath});

  @override
  _TopBarWidgetState createState() => _TopBarWidgetState();
}

class _TopBarWidgetState extends State<TopBarWidget> {
  final ImagePicker _picker = ImagePicker();
  final GlobalKey _menuKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  void _toggleMenu() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  // ✅ Pick Image & Upload
  Future<void> _pickAndUploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        // ✅ Web: Convert XFile to bytes
        Uint8List imageBytes = await pickedFile.readAsBytes();
        await _uploadProfilePictureWeb(imageBytes);
      } else {
        // ✅ Mobile: Use File Path
        File imageFile = File(pickedFile.path);
        await _uploadProfilePicture(imageFile);
      }
    }
  }

  // ✅ Upload Profile Picture (Mobile)
  Future<void> _uploadProfilePicture(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("http://localhost:3000/api/profile/upload-profile-picture"),
    );

    // ✅ Fetch Token from SharedPreferences
  String? token = await getLoginToken();
  if (token == null || token.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("User is not authenticated. Please login again.")),
    );
    return;
  }

  // ✅ Ensure Bearer Token Format
  request.headers['Authorization'] = "Bearer $token";
    request.files.add(
      await http.MultipartFile.fromPath("profilePicture", imageFile.path),
    );

    await _sendRequest(request);
  }

  // ✅ Upload Profile Picture (Web)
  Future<void> _uploadProfilePictureWeb(Uint8List imageBytes) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("http://localhost:3000/api/profile/upload-profile-picture"),
    );

    // ✅ Fetch Token from SharedPreferences
  String? token = await getLoginToken();
  if (token == null || token.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("User is not authenticated. Please login again.")),
    );
    return;
  }

  // ✅ Ensure Bearer Token Format
  request.headers['Authorization'] = "Bearer $token";
    request.files.add(
      http.MultipartFile.fromBytes("profilePicture", imageBytes,
          filename: "profile.jpg"),
    );

    await _sendRequest(request);
  }

  // ✅ Handle API Response
  Future<void> _sendRequest(http.MultipartRequest request) async {
    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      var data = json.decode(responseData);

      setState(() {
        widget.imgPath = data['imageUrl']; // ✅ Update UI with new image URL
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile picture updated successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload image.")),
      );
    }
  }

  // Function to Show Enlarged Profile Picture
  void _showProfilePopup() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: EdgeInsets.all(15.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Profile Picture",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                ),
              ),
              SizedBox(height: 10.h),

              // ✅ Show Profile Image or Fallback to Initials
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: (widget.imgPath.isNotEmpty &&
                        widget.imgPath != "null" &&
                        !widget.imgPath.contains(
                            "/static/image.png")) // ✅ Avoid broken image
                    ? Image.network(
                        widget.imgPath,
                        width: 200.w,
                        height: 200.h,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildFallbackAvatar(); // ✅ Handle loading errors
                        },
                      )
                    : _buildFallbackAvatar(), // ✅ Default avatar when image is missing
              ),
              SizedBox(height: 20.h),

              // ✅ Button to Change Profile Picture
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _pickAndUploadImage();
                },
                icon: Icon(Icons.edit, color: Colors.white),
                label: Text(
                  "Change Profile Picture",
                  style: TextStyle(color: AppColors.whiteColor),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.themeColor,
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// ✅ Function to Generate a Fallback Avatar with Initials
  Widget _buildFallbackAvatar() {
    return CircleAvatar(
      radius: 60,
      backgroundColor: Colors.purple.shade100, // ✅ Default background color
      child: Text(
        widget.userName[0].toUpperCase(), // ✅ Show first letter
        style: TextStyle(
            fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<void> _handleLogout() async {
    try {
      await removeLogin();
      await removeLoginToken();
      await removeUserData();
      log('User logged out'); // Log message after successful logout

      // Navigate to login screen
      Navigator.of(context, rootNavigator: true).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      log("Error during logout: $e");
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox =
        _menuKey.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // **Tap outside to close menu**
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleMenu, // Just closes menu, no logout here
              behavior: HitTestBehavior.translucent,
            ),
          ),

          // **Dropdown Menu**
          Positioned(
            top: offset.dy + renderBox.size.height,
            right: 10.w,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(10.r),
              color: Colors.white,
              child: Container(
                width: 150.w,
                padding: EdgeInsets.symmetric(vertical: 5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Icon(Icons.logout, color: AppColors.blackColor),
                      title: Text(
                        'Logout',
                        style: CustomTextInter.medium14(AppColors.blackColor),
                      ),
                      onTap: () async {
                        _toggleMenu(); // Close menu first
                        await _handleLogout(); // Perform logout
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final greeting = getGreeting();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        children: [
          // **Profile Image with Border and Tap Gesture**
          // ✅ Profile Image with Border and Tap Gesture
          GestureDetector(
            onTap: _showProfilePopup,
            child: CircleAvatar(
              radius: 25,
              backgroundColor:
                  AppColors.greenColor, // ✅ Default background color

              backgroundImage: (widget.imgPath.isNotEmpty &&
                      widget.imgPath != "null" &&
                      !widget.imgPath.contains(
                          "/static/image.png")) // ✅ Avoid broken images
                  ? NetworkImage(widget.imgPath)
                  : null, // ✅ Show initials if no image

              child: (widget.imgPath.isEmpty ||
                      widget.imgPath == "null" ||
                      widget.imgPath.contains("/static/image.png"))
                  ? Text(
                      widget.userName[0].toUpperCase(), // ✅ Show first letter
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
          ),

          SizedBox(width: 10),

          // **Greeting & User Name**
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: CustomTextInter.medium12(AppColors.fieldHintColor),
                ),
                Text(
                  widget.userName,
                  style: CustomTextInter.bold20(AppColors.blackColor),
                ),
              ],
            ),
          ),

          // **Notifications Icon**
          GestureDetector(
            onTap: () {
              moveToNext(context, NotificationScreen());
            },
            child: Icon(
              Icons.notifications_outlined,
              color: AppColors.themeColor,
            ),
          ),
          SizedBox(width: 10.w),

          // **Menu Icon**
          GestureDetector(
            key: _menuKey,
            onTap: _toggleMenu,
            child: Icon(Icons.menu_outlined),
          ),
        ],
      ),
    );
  }
}

class SearchWidget extends StatefulWidget {
  final Function(List<dynamic>)
      onSearchResults; // Callback to pass data to parent
  const SearchWidget({super.key, required this.onSearchResults});

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  TextEditingController searchController = TextEditingController();
  Timer? debounce;
  bool isSearching = false; // ✅ Indicates when the search is loading
  bool showNoJobsMessage = false; // ✅ Controls "No Jobs Found" message

  // Function to call the search API
  void searchJobs(String query) {
    if (query.isEmpty) {
      setState(() {
        widget.onSearchResults([]); // ✅ Reset to full list
        showNoJobsMessage = false; // ✅ Hide "No Jobs Found" message
      });
      return;
    }
    setState(() {
      isSearching = true; // ✅ Show loading indicator
      showNoJobsMessage = false; // ✅ Hide "No Jobs Found" while searching
    });

    // Debounce API calls to reduce excessive requests
    debounce?.cancel();
    debounce = Timer(Duration(milliseconds: 500), () async {
      try {
        var response = await ApiProvider().getRequest(
          apiUrl: '/api/jobs/search?jobName=$query',
        );
        setState(() {
          isSearching = false; // ✅ Hide loading indicator
        });

        if (response != null && response['success'] == true) {
          List<dynamic> searchResults = response['jobs'];
          widget.onSearchResults(searchResults);

          setState(() {
            showNoJobsMessage = searchResults.isEmpty; // ✅ Show/Hide message
          });
        } else {
          setState(() {
            widget.onSearchResults([]);
            showNoJobsMessage = true; // ✅ Show "No Jobs Found"
          });
        }
      } catch (e) {
        log('Error searching jobs: $e');
        setState(() {
          isSearching = false;
          widget.onSearchResults([]);
          showNoJobsMessage = true;
        });
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50.h,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: Offset(0, 3),
                  color: AppColors.blackColor.withOpacity(0.1),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 10.w, right: 10.w),
              child: TextFormField(
                controller: searchController,
                cursorColor: AppColors.fieldHintColor,
                style: CustomTextInter.medium12(AppColors.blackColor),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search Jobs..',
                  hintStyle: CustomTextInter.medium12(AppColors.fieldHintColor),
                ),
                onChanged: (value) {
                  searchJobs(value);
                },
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),

        // 🔍 Search Button
        GestureDetector(
          onTap: () {
            searchJobs(searchController.text);
          },
          child: Container(
            height: 50.h,
            width: 50.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.themeColor,
            ),
            child: Icon(Icons.search, color: AppColors.whiteColor),
          ),
        ),
        SizedBox(width: 10.w),

        // ⚙️ Filter Button
        GestureDetector(
          onTap: () {
            // TODO: Implement filter logic (show modal or navigate to filter screen)
          },
          child: Container(
            height: 50.h,
            width: 50.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.blackColor,
            ),
            child: Icon(Icons.tune, color: AppColors.whiteColor),
          ),
        ),
      ],
    );
  }
}

class FilterWidget extends StatefulWidget {
  final Function(String) onEmployerSelected;

  const FilterWidget({super.key, required this.onEmployerSelected});

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  List<dynamic> employers = [];
  String selectedEmployer = "";

  @override

  void initState() {
    super.initState();
    fetchEmployers();
  }

  void fetchEmployers() async {
    try {
      var response = await ApiProvider().getRequest(apiUrl: '/api/employers');
      setState(() {
        employers = response['employers'];
      });
    } catch (e) {
      print('Error fetching employers: $e');
    }
  }

  void showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Employer'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: employers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(employers[index]['companyLegalName']),
                  onTap: () {
                    setState(() {
                      selectedEmployer = employers[index]['_id'];
                    });
                    widget.onEmployerSelected(selectedEmployer);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: showFilterDialog,
      icon: Icon(Icons.tune, color: Colors.white),
      label: Text("Filter"),
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.blackColor),
    );
  }
}


class DateSelectionWidget extends StatefulWidget {
  final Function(String) onDateSelected;
  const DateSelectionWidget({super.key, required this.onDateSelected});

  @override
  _DateSelectionWidgetState createState() => _DateSelectionWidgetState();
}

class _DateSelectionWidgetState extends State<DateSelectionWidget> {
  DateTime selectedDate = DateTime.now();

  List<DateTime> getNextSevenDays() {
    return List.generate(7, (index) => DateTime.now().add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> dates = getNextSevenDays();

    return Row(
      children: [
        GestureDetector(
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime.now().subtract(Duration(days: 30)),
              lastDate: DateTime.now().add(Duration(days: 90)),
            );
            if (picked != null) {
              setState(() {
                selectedDate = picked;
              });

              // ✅ Convert DateTime to "YYYY-MM-DD" format
              String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
              widget.onDateSelected(formattedDate);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.fieldHintColor),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 18.sp, color: AppColors.blackColor),
                SizedBox(height: 3.h),
                Text("Go to", style: CustomTextInter.medium10(AppColors.blackColor)),
                Text("Date", style: CustomTextInter.medium10(AppColors.blackColor)),
              ],
            ),
          ),
        ),

        Container(
          width: 1.5.w,
          height: 50.h,
          color: AppColors.fieldHintColor,
          margin: EdgeInsets.symmetric(horizontal: 8.w),
        ),

        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: dates.map((date) {
                bool isSelected = selectedDate.day == date.day;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = date;
                    });

                    // ✅ Convert DateTime to "YYYY-MM-DD" format
                    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
                    widget.onDateSelected(formattedDate);
                  },
                  child: Container(
                    width: 55.w,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    margin: EdgeInsets.symmetric(horizontal: 5.w),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.themeColor : Color(0xFFE6F0FF),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][date.weekday % 7],
                          style: CustomTextInter.medium12(
                            isSelected ? AppColors.whiteColor : AppColors.blackColor,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          date.day.toString(),
                          style: CustomTextInter.bold18(
                            isSelected ? AppColors.whiteColor : AppColors.blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class JobWidget extends StatefulWidget {
  final dynamic jobData;
  final bool isBookmarkScreen;
  final VoidCallback? onRemoveBookmark;
  JobWidget(
      {super.key,
      required this.jobData,
      this.isBookmarkScreen = false,
      this.onRemoveBookmark});

  @override
  _JobWidgetState createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {
  late String jobId;
  String? userId;
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    jobId = widget.jobData['_id'];
    _fetchUserId();
  }

  // Fetch user ID from SharedPreferences
  Future<void> _fetchUserId() async {
    UserModel? user = await getUserData(); // ✅ Fetch user object

    if (user != null && user.id.isNotEmpty) {
      setState(() {
        userId = user.id; // ✅ Extract user ID
      });
      print('✅ Retrieved userId: $userId'); // Debugging log
      _checkBookmarkStatus();
    } else {
      print('❌ Error: userId is null or empty. Check login and storage.');
    }
  }

  // Fetch bookmarks from API
  Future<void> _checkBookmarkStatus() async {
    if (userId == null) return; // Avoid unnecessary API calls

    try {
      var response = await ApiProvider().getRequest(
        apiUrl: '/api/bookmark?userId=$userId',
      );

      if (response != null && response['success'] == true) {
        List<dynamic> bookmarks = response['bookmarks'];
        setState(() {
          isBookmarked =
              bookmarks.any((bookmark) => bookmark['jobId'] == jobId);
        });
      }
    } catch (e) {
      print('Error fetching bookmark status: $e');
    }
  }

  // Toggle bookmark via API
  Future<void> _toggleBookmark() async {
    if (userId == null) {
      print('❌ Error: userId is null. Cannot toggle bookmark.');
      return;
    }

    try {
      var response = await ApiProvider().postRequest(
        apiUrl: '/api/bookmark',
        data: {'jobId': jobId, 'userId': userId}, // Ensure both are sent
      );

      if (response != null && response['success'] == true) {
        setState(() {
          isBookmarked =
              response['bookmarkStatus']; // ✅ Update from API response
        });

        print('✅ Bookmark status updated successfully: $isBookmarked');
      } else {
        print('❌ Error: Bookmark API response unsuccessful.');
      }
    } catch (e) {
      print('❌ Error toggling bookmark: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(0, 2),
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// **Outlet Image & Badge**
          Stack(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.r),
                    topRight: Radius.circular(15.r),
                  ),
                  child: Image.network(
                    '${ApiProvider().baseUrl}${widget.jobData['outletImage']}',
                    height: 130.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Use local image if network fails
                      return Image.asset(
                        ImagePath.trayCollector, // Fallback image
                        height: 130.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  )),
              Positioned(
                top: 10.h,
                left: 10.w,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Colors.white,
                  ),
                  child: Text(
                    widget.jobData['outlet']['outletName'] ?? 'Unknown',
                    style: CustomTextInter.medium12(AppColors.blackColor),
                  ),
                ),
              ),
              Positioned(
                top: 10.h,
                right: 10.w,
                child: GestureDetector(
                  onTap: widget.isBookmarkScreen
                      ? widget.onRemoveBookmark
                      : _toggleBookmark,
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.isBookmarkScreen
                          ? Icons.delete
                          : (isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_border),
                      color: widget.isBookmarkScreen
                          ? Colors.red
                          : (isBookmarked ? Colors.blue : Colors.black),
                      size: 22.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
          //   ],
          // ),

          /// **Job Details**
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// **Job Title & Wage**
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.jobData['jobName'] ?? 'Job Title',
                        style: CustomTextInter.bold16(AppColors.blackColor),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Est. Wage:',
                          style: CustomTextInter.medium12(Colors.grey),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: Colors.yellow[700],
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      '\$${widget.jobData['estimatedWage'] ?? '0'}',
                                  style: CustomTextInter.bold14(
                                      AppColors.blackColor),
                                ),
                                // TextSpan(
                                //   text:
                                //       ' (${widget.jobData['payRatePerHour']})',
                                //   style: CustomTextInter.medium12(
                                //       AppColors.blackColor),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                /// **Location**
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.blue, size: 18.sp),
                    SizedBox(width: 5.w),
                    Text(
                      widget.jobData['shortAddress'] ??
                          widget.jobData['location'] ??
                          'Location',
                      style: CustomTextInter.medium12(AppColors.blackColor),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),

                /// **Outlet Timing**
                Text(
                  'Outlet timing: ${widget.jobData['outletTiming']}',
                  style: CustomTextInter.medium12(AppColors.blackColor),
                ),
                SizedBox(height: 5.h),

                /// **Slot Label (Trending, Limited Slots, etc.)**
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.orange[400],
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Text(
                    widget.jobData['slotLabel'] ?? 'New',
                    style: CustomTextInter.bold12(AppColors.whiteColor),
                  ),
                ),
                SizedBox(height: 12.h),

                /// **Apply Button**
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      /// ✅ Navigate to JobDetailsScreen and pass jobID
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomBarScreen(
                            index: -1,
                            child:
                                JobDetailsScreen(jobID: widget.jobData['_id']),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.themeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                    ),
                    child: Text(
                      'Apply',
                      style: CustomTextInter.bold16(AppColors.whiteColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
