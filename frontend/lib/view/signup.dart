import 'package:chat/controller/socketcontroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  SocketController socketController = Get.find();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
            socketController.signUpEmailController.value.clear();
            socketController.firstnameController.value.clear();
            socketController.signUpPasswordController.value.clear();
            socketController.secondnameController.value.clear();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.indigo,
          ),
        ),
        title: const Text(
          'Signup',
          style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w900),
        ),
      ),
      body: GetBuilder<SocketController>(
        builder: (controller) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30,),
               Center(
                child: Text(
                  'Join us now !',
                  style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                      fontSize: 55),
                ).animate().slideX(begin: -3 , end: 0 , duration: Duration(milliseconds: 500) , curve: Curves.easeIn),
              ),
              SizedBox(height: 60,),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Fill your information in the boxes bellow.',
                  style: TextStyle(fontSize: 16 , color: Colors.grey),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Firstname',
                        style: TextStyle(color: Colors.indigo, fontSize: 12),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == '') {
                            return 'Please Enter a valid firstname';
                          } else if (!GetUtils.isUsername(value!)) {
                            return 'Please Enter a valid firstname';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          socketController.emailController.value.text = value;
                        },
                        decoration:
                            const InputDecoration(hintText: 'Enter firstname'),
                        controller: socketController.firstnameController.value,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'Secondname',
                        style: TextStyle(color: Colors.indigo, fontSize: 12),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == '') {
                            return 'Please Enter a valid secondname';
                          } else if (!GetUtils.isUsername(value!)) {
                            return 'Please Enter a valid secondname';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          socketController.emailController.value.text = value;
                        },
                        decoration:
                            const InputDecoration(hintText: 'Enter secondname'),
                        controller: socketController.secondnameController.value,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'Email',
                        style: TextStyle(color: Colors.indigo, fontSize: 12),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == '') {
                            return 'Please enter a valid email';
                          } else if (!GetUtils.isEmail(value!)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          socketController.emailController.value.text = value;
                        },
                        decoration:
                            const InputDecoration(hintText: 'Enter email'),
                        controller:
                            socketController.signUpEmailController.value,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'Password',
                        style: TextStyle(color: Colors.indigo, fontSize: 12),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == '') {
                            return 'Password must have at least 6 characters';
                          } else if (value!.length < 6) {
                            return 'Password must have at least 6 characters';
                          }
                          return null;
                        },
                        obscureText: socketController.showPassword,
                        decoration: InputDecoration(
                            hintText: 'Enter password',
                            suffixIcon: IconButton(
                                onPressed: () {
                                  socketController.updateShowPasswordState();
                                  socketController.update();
                                },
                                icon: Icon(socketController.showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off  , color: Colors.grey))),
                        controller:
                            socketController.signUpPasswordController.value,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Hero(
                tag: 'signup',
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        socketController.signup({
                          'firstname':
                              socketController.firstnameController.value.text,
                          'secondname':
                              socketController.secondnameController.value.text,
                          'email':
                              socketController.signUpEmailController.value.text,
                          'password': socketController
                              .signUpPasswordController.value.text,
                        });

                        socketController.checksignup();

                        Future.delayed(
                          Duration(milliseconds: 300),
                          () {
                            socketController.firstnameController.value.clear();
                            socketController.secondnameController.value.clear();
                            socketController.signUpEmailController.value
                                .clear();
                            socketController.signUpPasswordController.value
                                .clear();
                          },
                        );
                      }
                    },
                    style: const ButtonStyle(),
                    child: const Text(
                      'Signup',
                      style: TextStyle(color: Colors.indigo),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
