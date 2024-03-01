import 'package:chat/controller/socketcontroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final SocketController socketController = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
            socketController.emailController.value.clear();
            socketController.passwordController.value.clear();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.indigo,
          ),
        ),
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w900),
        ),
      ),
      body: GetBuilder<SocketController>(
        builder: (controller) => SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width ,
            height: MediaQuery.of(context).size.height,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50,),
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 20),
                   child: Center(
                    child: Text(
                      'Happy to see you again !',
                      style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                          fontSize: 55),
                    ).animate().slideX(begin: -3 , end: 0 , duration: Duration(milliseconds: 500) , curve: Curves.easeIn),
                                 ),
                 ),
                SizedBox(height: 10,),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Fill your information in the boxes bellow.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500 , color: Colors.grey),
                  ),
                ),
                SizedBox(height: 40,),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          controller: socketController.emailController.value,
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
                          obscureText: controller.showPassword,
                          decoration: InputDecoration(
                              hintText: 'Enter password',
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    socketController.updateShowPasswordState();
                                    socketController.update();
                                  },
                                  icon: Icon(socketController.showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off , color: Colors.grey,))),
                          controller: socketController.passwordController.value,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Hero(
                  tag: 'login',
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          socketController.login({
                            'email': socketController.emailController.value.text,
                            'password':
                                socketController.passwordController.value.text,
                          });
          
                          socketController.checklogin();
                          socketController.fetchActiveUsers();
          
                          Future.delayed(
                            Duration(milliseconds: 300),
                            () {
                              socketController.emailController.value.clear();
                              socketController.passwordController.value.clear();
                            },
                          );
                        }
                      }, style: ButtonStyle(
                          elevation: MaterialStatePropertyAll(10),
                        ) ,
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.indigo),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
