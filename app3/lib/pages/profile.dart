import 'dart:io';

import 'package:app3/pages/onboarding.dart';
import 'package:app3/services/auth.dart';
import 'package:app3/services/shared_pref.dart';
import 'package:app3/widget/support_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? image, name, email;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  Future<void> getthesharedpref() async {
    image = await SharedPreferenceHelper().getUserImage();
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  uploadItem() async {
    if (selectedImage != null) {
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("blogImage").child(addId);

      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      var downloadUrl = await (await task).ref.getDownloadURL();
      await SharedPreferenceHelper().saveUserImage(downloadUrl);
    }
  }

  @override
  void initState() {
    super.initState();
    getthesharedpref();
  }

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      uploadItem();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f2f2),
        centerTitle: true,
        title: Text(
          "Profile",
          style: AppWidget.boldTextFeildStyle().copyWith(
            fontSize: 24.0,
          ),
        ),
      ),
      backgroundColor: const Color(0xfff2f2f2),
      body: name == null
          ? Center(
              child: CircularProgressIndicator()) // Thêm một chỉ báo đang tải
          : Container(
              child: Column(
                children: [
                  selectedImage != null
                      ? GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  60), // Đặt bán kính lớn hơn cho hình tròn
                              child: Image.file(
                                selectedImage!,
                                height: 150.0,
                                width: 150.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Center(
                              child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(60), //code toi day roi
                            child: Image.network(
                              image!,
                              height: 150.0,
                              width: 150.0,
                              fit: BoxFit.cover,
                            ),
                          )),
                        ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: EdgeInsets.only(left: 10.0,right: 10.0, top: 10.0,bottom: 10.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Icon(Icons.person_outline, size: 35.0,),
                            SizedBox(width:10.0,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start ,
                              children: [
                                Text(
                                  "Name",
                                  style: AppWidget.lightTextFeildStyle(),
                                ),
                                Text(
                                  name!,
                                  style: AppWidget.semiboldTextFeildStyle(),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                   SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: EdgeInsets.only(left: 10.0,right: 10.0, top: 10.0,bottom: 10.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Icon(Icons.mail_outline, size: 35.0,),
                            SizedBox(width:10.0,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start ,
                              children: [
                                Text(
                                  "Email",
                                  style: AppWidget.lightTextFeildStyle(),
                                ),
                                Text(
                                  email!,
                                  style: AppWidget.semiboldTextFeildStyle(),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                   SizedBox(
                    height: 20.0,
                  ),
                  GestureDetector(
                    onTap: ()async{
                      await AuthMethods().SignOut().then((value) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Onboarding()));
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: EdgeInsets.only(left: 10.0,right: 10.0, top: 10.0,bottom: 10.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Icon(Icons.logout_outlined, size: 35.0,),
                              SizedBox(width:10.0,),
                              Text("LogOut", style: AppWidget.semiboldTextFeildStyle(),),
                              Spacer(),
                              Icon(Icons.arrow_forward_ios_outlined)
                            ],
                            
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  GestureDetector(
                    onTap: ()async{
                      await AuthMethods().deleteuser().then((value){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Onboarding()));
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: EdgeInsets.only(left: 10.0,right: 10.0, top: 10.0,bottom: 10.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline, size: 35.0,),
                              SizedBox(width:10.0,),
                              Text("Delete Account", style: AppWidget.semiboldTextFeildStyle(),),
                              Spacer(),
                              Icon(Icons.arrow_forward_ios_outlined)
                            ],
                            
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
