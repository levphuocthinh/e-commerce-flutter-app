import 'package:app3/pages/signup.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 252, 252),
      body: Container(
        margin: const EdgeInsets.only(top: 50.0, left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
                "images/a-beats-studio-3-red-limited-songlongmedia.jpg.webp"),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                " Khám Phá Các \n Sản Phẩm Bán\n Chạy Nhất 🔥",
                style: TextStyle(
                  color: Color.fromARGB(255, 7, 7, 0),
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUp()),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 20.0),
                    padding: const EdgeInsets.all(30),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 13, 13, 13),
                        shape: BoxShape.circle),
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
