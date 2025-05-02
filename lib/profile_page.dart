import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:arohana_educational_society/detailspage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ProfilePage extends StatefulWidget {
  final String identityToken;

  const ProfilePage({
    super.key,
    required this.identityToken,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String branchName;
  late String username;
  late String branchLogo;
  late int StudentEnrollmentID;
  late int UserID;
  late String encryptedParam;
  late String param = '';
  late String fullName;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  String getEnCreptData(String param) {
    final key1 = enc.Key.fromUtf8("AI0WZVEU922NW4JX4HNKRVYGE2OST619");
    final iv = enc.IV.fromUtf8("PSBCNLAQORFKUPBZ");
    var encrypter = enc.Encrypter(enc.AES(key1, mode: enc.AESMode.cbc));
    var encrypted = encrypter.encrypt(param, iv: iv);
    return encrypted.base64;
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      branchName = prefs.getString('branchName') ?? '';
      username = prefs.getString('userName') ?? '';
      branchLogo = prefs.getString('branchLogo') ?? '';
      StudentEnrollmentID = prefs.getInt('StudentEnrollmentID') ?? 0;
      UserID=prefs.getInt('UserID')??0;
      fullName=prefs.getString("fullName")??'';

      param =  '''{
            "userID": $UserID,
            "studentEnrollmentID": $StudentEnrollmentID,
      }''';

      encryptedParam = getEnCreptData(param);
      print(encryptedParam);
    });

    await fetchSiblingData(prefs);
  }

  Future<void> fetchSiblingData(SharedPreferences prefs) async {
    final dio = Dio();
    dio.options.baseUrl = 'https://devparentapi.myclassboard.com/AppGraph';
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"]='Bearer ${widget.identityToken}';

    final query='''query GetStudentSiblingAccounts {
      getStudentSiblingAccounts(
          enc: { data: "$encryptedParam" }
      ) {
        fullName
        locationName
        locationID
        organisationName
        organisationID
        branchName
        branchID
        branchAddress
        section
        className
        academicYear
        studentEnrollmentCode
        gender
        fatherName
        motherName
        fatherPhone
        fatherEmailID
        motherPhone
        motherEmailID
        studentReferencesCode
        address
        photoUpload
        academicYearID
        classID
        branchSectionID
        studentEnrollmentId
        userID
        userTypeID
        isFeeDue
        studentGUID
        branchGUID
        orgGUID
        facebookURL
        likedInURL
        instagramURL
        tumblrUrl
      }
    }''';

    //httpResponse = await dio.post(Constants.graphQL_domainURL,data: {"query":query,
    // "variables": {}});
    try {
      print("GraphQL Query: $query");
      final response = await dio.post('https://devparentapi.myclassboard.com/AppGraph',
        data: {'query': query, 'variables': {}},);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['data'] != null &&
            data['data']['getStudentSiblingAccounts'] != null) {
          final siblingAccounts = data['data']['getStudentSiblingAccounts'];
          for (var sibling in siblingAccounts) {
            String fullName = sibling['fullName'];
            String className = sibling['className'];
            String studentEnrollmentCode = sibling['studentEnrollmentCode'];
            String photoUrl = sibling['photoUpload'];

            await prefs.setString('siblingFullName', fullName);
            await prefs.setString('siblingClassName', className);
            await prefs.setString(
                'siblingEnrollmentCode', studentEnrollmentCode);
            await prefs.setString('siblingPhotoUrl', photoUrl);
            fullName = sibling['fullName'];
            setState(() {
              this.fullName = fullName;
            });
            print("Sibling Name: $fullName");
            print("Class: $className");
            print("Enrollment Code: $studentEnrollmentCode");
            print("Photo URL: $photoUrl");
          }

          print("Sibling data saved to SharedPreferences");
        } else if (data['errors'] != null) {
          print("GraphQL Errors: ${data['errors']}");
        }
      } else {
        print("GraphQL request failed with status: ${response.statusCode}");
        print("Response Data: ${response.data}");
      }
    } catch (e) {
      print("Error while making GraphQL request: $e");
      print("GraphQL request failed with status: ${encryptedParam}");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(branchName),
        backgroundColor: Colors.teal.shade200,
        actions: [
          IconButton(
            icon: Icon(Icons.person_add_alt),
            onPressed: () => print("clicked"),
          ),
          IconButton(
            onPressed: () => showlanguageBottomsheet(context),
            icon: Icon(Icons.language),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Image.network(
            branchLogo,
            width: double.infinity,
            height: 200,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                Text("Failed to load image"),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              Get.to(() =>
                  detailspage());
            },
            child: Card(
              color: Colors.teal.shade300,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 12,
              shadowColor: Colors.blueAccent,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    CircleAvatar(radius: 30, backgroundColor: Colors.white),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text("Enrollment ID: $StudentEnrollmentID"),
                          Text(username),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Language selection bottom sheet
  void showlanguageBottomsheet(BuildContext context) {
    final List<Map<String, String>> languages = [
      {'name': 'English', 'code': 'en'},
      {'name': 'हिन्दी', 'code': 'hi'},
      {'name': 'తెలుగు', 'code': 'te'},
      {'name': 'தமிழ்', 'code': 'ta'},
      {'name': 'ಕನ್ನಡ', 'code': 'kn'},
      {'name': 'मराठी', 'code': 'mr'},
      {'name': 'ગુજરાતી', 'code': 'gu'},
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Text("Select Language".tr, style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
                  Spacer(),
                  IconButton(
                      onPressed: () => Get.back(), icon: Icon(Icons.close)),
                ],
              ),
              Divider(),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    var lang = languages[index];
                    return Column(
                      children: [
                        ListTile(
                          title: Text(lang['name']!),
                          trailing: Get.locale?.languageCode == lang['code']
                              ? Icon(Icons.check, color: Colors.black)
                              : null,
                          onTap: () {
                            _loadPreferences();
                            // Get.updateLocale(Locale(lang['code']!));
                            // Get.back();
                            // Get.snackbar(
                            //   'Alert'.tr,
                            //   '${'Language changed to '.tr}${lang['name']}',
                            //   snackPosition: SnackPosition.TOP,
                            //   backgroundColor: Colors.teal.shade100,
                            //   colorText: Colors.black,
                            // );
                          },
                        ),
                        Divider(height: 2, thickness: 3, color: Colors.black),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

