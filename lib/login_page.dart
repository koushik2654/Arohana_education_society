import 'dart:convert';
import 'package:arohana_educational_society/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:http/http.dart' as http;
import 'package:arohana_educational_society/forgot_page.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class loginpage extends StatefulWidget {
  const loginpage({super.key});

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  bool _rememberMe = false;
  String givenName="";
  String profilePicture="";


  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    final key = enc.Key.fromUtf8("AI0WZVEU922NW4JX4HNKRVYGE2OST619");
    final iv = enc.IV.fromUtf8("PSBCNLAQORFKUPBZ");
    String _encryptData(String username, String password) {
      final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));

      Map<String, dynamic> payload = {
        "userName": "Corp53Schools-$username",
        "password": password,
        "userGUID": "",
        "device_type": "{androidId: U1UGS34.23-82-2-7}",
        "deviceModel": "A",
        "device_id": "59774f0918e1ccb1b8d898021d8dfcba07bf88f6",
        "device_token": "dRz9gvyhQUmo4JvEy-7xBy:APA91bFL1CjdcRyYQuagRik4lyw97ckkmS5aSylkoiVPzyvbIbpVq3zidaPihw1IkbtxAqCxzNxEF9tKZ32R51I6u-Wt4vtV1yEMo7kPa1UY7NSbhzMXgus",
        "usercurrentversion": "2.4.9",
        "packagename": "com.mcb.myclassboard.activity",
        "apikey": "AI0WZVEU922NW4JX4HNKRVYGE2OST619",
        "organisationID": 24
      };

      String jsonString = jsonEncode(payload);
      final encrypted = encrypter.encrypt(jsonString, iv: iv);

      return encrypted.base64;
    }
    Future<void> _sendEncryptedData() async {
      if (!_formKey.currentState!.validate()) return;

      String apiUrl = "https://devparentapi.myclassboard.com/api/Mobile_API_/chkMobileLogin";
      String username = _usernameController.text.trim();
      String password = _passwordController.text.trim();
      String encryptedData = _encryptData(username, password);

      Map<String, dynamic> jsonBody = {
        "data": encryptedData,

      };
      try {
        final response = await http.post(Uri.parse(apiUrl),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",},
          body: jsonEncode(jsonBody),
        );
        print("Sent JSON: ${jsonEncode(jsonBody)}");
        print("Response Status: ${response.statusCode}");
        print("Response Body: ${response.body}");
        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);

          if (responseData.containsKey("response")) {
            final decodedResponse = jsonDecode(responseData["response"]);

            if (decodedResponse.containsKey("IdentityToken")) {
              try {
                String identityToken = decodedResponse["IdentityToken"];
                final jwt = JWT.decode(identityToken);  // Decoding the JWT
                print("Decoded JWT Data: ${jwt.payload}");
                setState(() {
                  givenName = jwt.payload["given_name"]?.toString() ?? "No Name";
                  profilePicture = jwt.payload["picture"]?.toString() ?? "";
                });
                print('${jwt.payload["picture"]}');
              } catch (e) {
                print("Error decoding JWT: $e");
              }
            }

            if (decodedResponse.containsKey("StudentData")) {
              final studentData = decodedResponse["StudentData"];
              String branchName = studentData["BranchName"]?.toString() ?? "No Branch Name";
              String userName = studentData["UserName"]?.toString() ?? "No userName";
              String branchLogo = studentData["BranchLogo_App"]?.toString() ?? "";
              int StudentEnrollmentID = (studentData["StudentEnrollmentID"] is int)
                  ? studentData["StudentEnrollmentID"]
                  : int.tryParse(studentData["StudentEnrollmentID"].toString()) ?? 0;
              Get.to(() => ProfilePage(
                branchName: branchName,
                branchLogo: branchLogo,
                StudentEnrollmentID:StudentEnrollmentID,
                username: userName,
                givenName:givenName,
                picture: profilePicture,
              ));
            } else {
              ScaffoldMessenger.of(Get.context!).showSnackBar(
                SnackBar(content: Text("Login Successful, but no StudentData found!")),
              );
            }
          } else {
            ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text("Login Successful, but missing 'response' data!")),
            );
          }
        } else {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(content: Text("Login Failed: ${response.body}")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text("invalid username or password")),
        );
      }
    }
    return Scaffold(appBar: AppBar(backgroundColor: Colors.teal.shade500,toolbarHeight: 0,),
        body:Column(children: [Container(
          width: double.infinity,color:Colors.white,
          padding: EdgeInsets.symmetric(vertical: 50),
          child: Column(
            children: [
              SizedBox(height: 40),Image.network("https://cdn-mcb.myclassboard.com/gcscorp53schools/24/50/BranchLogUploads/12025/0201251703183477.jpg",
                height: 100,
                fit: BoxFit.contain,),
              SizedBox(height: 20,),
              Text('Arohana Educations Society',
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20 ),),
              SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // M C B colored dots
                  CircleAvatar(radius: 12, backgroundColor: Colors.red, child: Text("M", style: TextStyle(fontSize: 14, color: Colors.white))),
                  SizedBox(width: 1),
                  CircleAvatar(radius: 12, backgroundColor: Colors.orange, child: Text("C", style: TextStyle(fontSize: 14, color: Colors.white))),
                  SizedBox(width: 1),
                  CircleAvatar(radius: 12, backgroundColor: Colors.blue, child: Text("B", style: TextStyle(fontSize: 14, color: Colors.white))),
                ],
              ),
            ],
          ),
        ),
          Expanded(child:
          SingleChildScrollView(child:
          Padding(padding: const EdgeInsets.all(20),
            child:
            Form(
              key:_formKey,child:Column(
              children: [
                SizedBox(height: 50),
                Align(alignment: Alignment.centerLeft,
                  child: Text('Username / Email',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 18),),
                ),
                SizedBox(height: 10),TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      fillColor: Colors.white,
                      filled: true,
                      border: InputBorder.none),
                  validator: (value){
                    if (value==null || value.isEmpty)
                      return "username cannot be empty";
                    return null;
                  },
                ),
                SizedBox(height: 30),
                Align(alignment: Alignment.centerLeft,
                  child: Text('Password',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 18),),
                ),
                SizedBox(height: 10),TextFormField(
                  controller: _passwordController,obscureText: true,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.key),
                      fillColor: Colors.white,
                      filled:true,
                      border: InputBorder.none),
                  validator: (value){
                    if (value==null || value.isEmpty)
                      return "password cannot be empty";
                    return null;
                  },
                ),
                SizedBox(height: 10),
                CheckboxListTile(controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.teal.shade600,
                  title: Text('Remember me',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,color: Colors.teal.shade700,
                      fontSize: 17,
                    ),
                  ),
                  value: _rememberMe,
                  onChanged: (bool? value) {
                    setState(() {
                      _rememberMe = value!;
                    });
                  },
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                    onPressed: (){
                      _sendEncryptedData();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 150,vertical: 15)
                    ),
                    child:Row(
                      children: [
                        Text('Login',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                        SizedBox(width:40),Icon(Icons.arrow_forward,color: Colors.white,size: 20,)
                      ],
                    )),
                SizedBox(height: 20,),InkWell(child:
                Text("Forgot Username/Password",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.orangeAccent.shade700),),
                    onTap: (){
                      Get.to(ForgotPage());
                    }
                ),SizedBox(height: 20),
                Align(alignment: Alignment.center,
                  child: Text('OR',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 18),),
                ),SizedBox(height: 20),
                Align(alignment: Alignment.center,
                  child: Text('Sign in with',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 18),),
                ),
                SizedBox(height: 20),Padding(padding: EdgeInsets.symmetric(horizontal: 20)
                  ,child:Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Image.asset("assets/mcb/apple.webp", fit: BoxFit.contain),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Image.asset("assets/mcb/google.webp", fit: BoxFit.contain),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Image.asset("assets/mcb/microsoft.webp", fit: BoxFit.contain),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text("By logging in ,you agree to MYClassBoard's Conditions of Use and Privacy Policy",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 18),),
                ),
              ],
            ),
            ),
          ))
          ),
        ],)
    );
  }
}
