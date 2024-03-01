import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import 'login.dart';
import 'signup.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String message = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            children: [
              const SizedBox(
                height: 70,
              ),
              Center(
                child: Image.asset(
                  'assets/image/smile.png',
                  color: Colors.indigo,
                  height: 240,
                ).animate().slide(
                  begin: const Offset(0.0, -2),
                  end: const Offset(0.0, 0.0),
                  curve: Curves.easeIn,
                  duration: const Duration(milliseconds: 800) ).fade(duration: const Duration(milliseconds: 700)),
              ),
              const SizedBox(
                height: 10,
              ),
               Center(
                child: const Text(
                  'Welcome !',
                  style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                      fontSize: 45),
                ).animate().slide(
                  begin: const Offset(0.0, -1),
                  end: const Offset(0.0, 0.0),
                  curve: Curves.easeIn,
                  duration: const Duration(milliseconds: 700) ).fade(duration: const Duration(milliseconds: 700)),
              ),
              const SizedBox(
                height: 30,
              ),
              const SizedBox(
                height: 100,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'login',
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(Login());
                        },
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.w900),
                        ),
                         style: ButtonStyle(
                          elevation: MaterialStatePropertyAll(10),
                        ) ,
                      ),
                    ),
                  ),
                  Hero(
                    tag: 'signup',
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(const Signup());
                        },
                        style: ButtonStyle(
                          elevation: MaterialStatePropertyAll(10),
                        ) ,
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ),
                ],
              ).animate().slide(begin: const Offset(0, 2) , end: const Offset(0, 0) , curve: Curves.easeIn , duration: const Duration(milliseconds: 700)),
            ],
          ),
        ),
      ),
    );
  }
}
