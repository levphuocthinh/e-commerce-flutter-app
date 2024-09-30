import 'package:app3/pages/bottomnav.dart';
import 'package:app3/services/database.dart';
import 'package:app3/services/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app3/pages/login.dart';
import 'package:app3/widget/support_widget.dart';
import 'package:random_string/random_string.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? name, email, password;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController mailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  registration() async {
    if (password != null && name != null && email != null) {
      if (password!.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text("Mật khẩu phải có ít nhất 6 ký tự")));
        return;
      }

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email!, password: password!);

        await userCredential.user?.sendEmailVerification(); // Gửi email xác thực

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Đăng ký thành công! Kiểm tra email để xác thực")));
        
        String Id = randomAlphaNumeric(10);
        await SharedPreferenceHelper().saveUserEmail(mailcontroller.text);
        await SharedPreferenceHelper().saveUserId(Id);
        await SharedPreferenceHelper().saveUserName(namecontroller.text);
        await SharedPreferenceHelper().saveUserImage("images/96688909-e8e4-4c31-9c35-aea1a3a28044.jpg");
        
        Map<String, dynamic> userInfoMap = {
          "Tên": namecontroller.text,
          "Email": mailcontroller.text,
          "Id": Id,
          "Image": "https://firebasestorage.googleapis.com/v0/b/app3-a10c3.appspot.com/o/blogImage%2F9l1083fj77?alt=media&token=b073d4ef-70f1-45e3-ae5f-dab985"
        };

        await DatabaseMethods().addUserDetails(userInfoMap, Id);
        Navigator.push(context, MaterialPageRoute(builder: (content) => BottomNav()));
        
        // Xóa thông tin trong các trường
        namecontroller.clear();
        mailcontroller.clear();
        passwordcontroller.clear();
        
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text("Mật khẩu bạn cung cấp quá yếu")));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text("Tài khoản này đã tồn tại")));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0, bottom: 40.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("images/22222.png"),
                Center(
                  child: Text("Đăng Ký", style: AppWidget.semiboldTextFeildStyle()),
                ),
                const SizedBox(height: 20.0),
                Center(
                  child: Text("Đăng nhập để vào cửa hàng 🛍", style: AppWidget.lightTextFeildStyle()),
                ),
                const SizedBox(height: 40.0),
                Text("Tên :", style: AppWidget.semiboldTextFeildStyle()),
                const SizedBox(height: 20.0),
                Container(
                  padding: const EdgeInsets.only(left: 20.0),
                  decoration: BoxDecoration(color: const Color(0xFFF4F5F9), borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Hãy nhập tên của bạn vào';
                      }
                      return null;
                    },
                    controller: namecontroller,
                    decoration: const InputDecoration(border: InputBorder.none, hintText: "Tên"),
                  ),
                ),
                const SizedBox(height: 20.0),
                Text("Email :", style: AppWidget.semiboldTextFeildStyle()),
                const SizedBox(height: 20.0),
                Container(
                  padding: const EdgeInsets.only(left: 20.0),
                  decoration: BoxDecoration(color: const Color(0xFFF4F5F9), borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Hãy nhập email bạn vào đây';
                      }
                      return null;
                    },
                    controller: mailcontroller,
                    decoration: const InputDecoration(border: InputBorder.none, hintText: "Email"),
                  ),
                ),
                const SizedBox(height: 20.0),
                Text("Mật Khẩu :", style: AppWidget.semiboldTextFeildStyle()),
                const SizedBox(height: 20.0),
                Container(
                  padding: const EdgeInsets.only(left: 20.0),
                  decoration: BoxDecoration(color: const Color(0xFFF4F5F9), borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Hãy nhập tên mật khẩu của bạn vào đây';
                      }
                      return null;
                    },
                    controller: passwordcontroller,
                    decoration: const InputDecoration(border: InputBorder.none, hintText: "Mật Khẩu"),
                  ),
                ),
                const SizedBox(height: 30.0),
                GestureDetector(
                  onTap: () {
                    if (_formkey.currentState!.validate()) {
                      setState(() {
                        name = namecontroller.text;
                        email = mailcontroller.text;
                        password = passwordcontroller.text;
                      });
                      registration();
                    }
                  },
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text("Đăng Ký",
                            style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Đã có tài khoản rồi", style: AppWidget.lightTextFeildStyle()),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const LogIn()));
                      },
                      child: const Text(" Đăng Nhập ",
                          style: TextStyle(color: Colors.green, fontSize: 18.0, fontWeight: FontWeight.w500)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
