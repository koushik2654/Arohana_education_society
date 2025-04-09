import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:get/get.dart';
import 'package:arohana_educational_society/details_page.dart';

class ProfilePage extends StatelessWidget {
  final String? branchName;
  final String? branchLogo;
  final String? picture;
  final String? username;
  final String? givenName;
  final int StudentEnrollmentID;


  const ProfilePage({super.key,
   this.branchName,
  this.branchLogo,
  required this.StudentEnrollmentID,
  this.picture,
  this.username,
  this.givenName
  });

  void showlanguageBottomsheet(BuildContext context){
    final List<Map<String,String>> languages=[
      {'name': 'English', 'code': 'en'},
      {'name': 'हिन्दी', 'code': 'hi'},
      {'name': 'తెలుగు', 'code': 'te'},
      {'name': 'தமிழ்', 'code': 'ta'},
      {'name': 'ಕನ್ನಡ', 'code': 'kn'},
      {'name': 'मराठी', 'code': 'mr'},
      {'name': 'ગુજરાતી', 'code': 'gu'},
    ];
    showModalBottomSheet(context: context, builder: (context){
      return Padding(padding: EdgeInsets.all(20),child: Column(
        children: [Row(children: [
          Text("Select Language".tr,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
         Spacer(), IconButton(onPressed: ()=>Get.back(), icon:Icon(Icons.close))
        ],),
          Divider(),
          Expanded(child:
          ListView.builder(
            shrinkWrap: true,
            itemCount: languages.length,
            itemBuilder: (context, index) {
              var lang = languages[index];
              return Column(
                children: [ListTile(
                title: Text(lang['name']!),
                  trailing: Get.locale?.languageCode == lang['code']
                      ? Icon(Icons.check, color: Colors.black) : null,
                onTap: () {
                  Get.updateLocale(Locale(lang['code']!));
                  Get.back();
                  Get.snackbar('Alert'.tr, '${'Language changed to '.tr},${lang['name']}',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.teal.shade100,
                    colorText: Colors.black,
                  );// Close modal bottom sheet
                },
                ),Divider(height: 2,thickness: 3,color: Colors.black,)
              ],
              );
            },
          )
          ),
        ],
      ),
      );
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(branchName ?? "No branch name",style: TextStyle(fontSize: 23,fontWeight: FontWeight.w500),),actions: [
          IconButton(icon:Icon(Icons.person_add_alt),
          onPressed: (){
            print("clicked");
          },
          ),
        IconButton(onPressed: ()=>showlanguageBottomsheet(context), icon:Icon(Icons.language))
      ],
        backgroundColor: Colors.teal.shade200,),
      body: Column(
        children: [
          SizedBox(height: 20),
          Image.network(branchLogo ?? "",
            width: double.infinity, height: 200,fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Text("Failed to load image");
            },
          ),
          SizedBox(height: 20),InkWell(
              child: Card(color: Colors.teal.shade300,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
            elevation: 12,
            shadowColor: Colors.blueAccent,
            child:Padding(padding: const EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(borderRadius: BorderRadius.circular(60),
                          child: Image.network(picture??"",errorBuilder: (context,error,stackTrace,){
                            return Text("Failed to load image");}
                          ),
                        ),
                        SizedBox(height: 10,),
                        Expanded(child: Column(
                          children: [
                            Text("${username.toString()}", style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),
                            Text("${givenName.toString()}", style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),
                            Text("${StudentEnrollmentID.toString()}", style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),
                            ),

                          ],)
                        ),
                        SizedBox(height: 10,),Icon(Icons.arrow_forward_ios,color: Colors.white,)
                      ],
                    ),
                  ]
              ),
            ),
          ),
            onTap: (){
                Get.to(DetailsPage(branchName:branchName));
            },)
        ],
      ),
    );
  }
}
