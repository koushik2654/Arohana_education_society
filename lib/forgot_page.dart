import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final TextEditingController _usernamecontroller = TextEditingController();
  String? _selectedOption = "Email ID"; // Default selected option

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password'), backgroundColor: Colors.teal),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [SizedBox(height: 10),
            Text(
              'Username',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _usernamecontroller,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                fillColor: Colors.white,
                filled: true,
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return "Username cannot be empty";
                return null;
              },
            ),
            SizedBox(height: 10),
            Text('Search by',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 20,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Email ID'),
                    value: "Email ID",
                    groupValue: _selectedOption,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedOption = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Mobile Number'),
                    value: "Mobile Number",
                    groupValue: _selectedOption,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedOption = value;
                      });
                    },
                  ),
                ),
              ],
            ),SizedBox(height: 25,),
            Text(_selectedOption??"Select option",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
            SizedBox(height: 10),
            TextFormField(
              controller: _usernamecontroller,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                fillColor: Colors.white,
                filled: true,
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return "Username cannot be empty";
                return null;
              },
            ),
            SizedBox(height: 30,),
            ElevatedButton(
                onPressed: (){

                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 100,vertical: 15)
                ),
                child:Row(
                  children:[Expanded(child:
                    Text('new password',overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                  ),
                    SizedBox(width:50),Icon(Icons.arrow_forward,color: Colors.white,size: 25,),
                  ]
                ),
            )
          ],
        ),
      ),
    );
  }
}