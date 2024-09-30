import 'package:app3/pages/bottomnav.dart';
import 'package:app3/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:app3/pages/signup.dart';
import 'package:app3/widget/support_widget.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String email = "", password = "";
  
  TextEditingController mailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

userLogin()async{
  try{
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

    Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomNav()));
  } on FirebaseAuthException catch(e) {
    if(e.code=='user-not-found'){
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "Không tìm thấy tài khoản email của người dùng",
              style: TextStyle(fontSize: 20.0),
            )));
    }
    else if(e.code=="sai mật khẩu rồi ><"){
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "Sai mật khẩu rồi ><",
              style: TextStyle(fontSize: 20.0),
            )));
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(
            top: 40.0, left: 20.0, right: 20.0, bottom: 40.0),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("images/22222.png"),
              Center(
                child: Text(
                  "Đăng Nhập",
                  style: AppWidget.semiboldTextFeildStyle(),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Center(
                child: Text(
                  "Đăng nhập để vào cửa hàng 🛍",
                  style: AppWidget.lightTextFeildStyle(),
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              Text(
                "Email :",
                style: AppWidget.semiboldTextFeildStyle(),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                padding: const EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                    color: const Color(0xFFF4F5F9),
                    borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                   validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Hãy nhập Email bạn vào đây';
                    }
                    return null;
                  },
                  controller: mailcontroller,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Email"),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                "Mật Khẩu :",
                style: AppWidget.semiboldTextFeildStyle(),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                padding: const EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                    color: Color(0xFFF4F5F9),
                    borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordcontroller,
                   validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Hãy nhập mật khẩu của bạn vào đây';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Mật Khẩu"),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Quên mật khẩu :< ",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(
                height: 30.0,
              ),
              GestureDetector(
                onTap: (){
                  if(_formkey.currentState!.validate()){
                    setState(() {
                      email=mailcontroller.text;
                      password=passwordcontroller.text;
                    });
                  }
                  userLogin();
                },
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Center(
                        child: Text(
                      "Đăng Nhập",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Không có tài khoản",
                    style: AppWidget.lightTextFeildStyle(),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp()));
                    },
                    child: const Text(
                      " Đăng Ký ",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
