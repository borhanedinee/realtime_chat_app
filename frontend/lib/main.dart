import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controller/socketcontroller.dart';
import 'view/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(MainApp());
}

SharedPreferences? sharedPreferences;

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final SocketController socketController = Get.put(SocketController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true , ),
      home: const Scaffold(
        body: Home(),
      ),
    );
  }
}
