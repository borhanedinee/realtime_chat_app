
import 'package:chat/services/srvices.dart';
import 'package:chat/view/home.dart';
import 'package:chat/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/image/profilee.png')),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${sharedPreferences!.getString('userfirstname')} ${sharedPreferences!.getString('usersecondname')}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold , color: Colors.grey),
                  ),
                  Text(
                    '${sharedPreferences!.getString('useremail')}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey
                    ),
                  ),
                  Text(
                    'You joined ${Services.calculateMembershipDuration(DateTime.parse(sharedPreferences!.getString('userjoinedat')!))} ago',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: () {
                      Get.off(Home());
                      sharedPreferences!.clear();
                    }, child: const Text('Logout')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
