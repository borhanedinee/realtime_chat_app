
import 'package:chat/controller/socketcontroller.dart';
import 'package:chat/services/srvices.dart';
import 'package:chat/view/home.dart';
import 'package:chat/main.dart';
import 'package:chat/model/user.dart';
import 'package:chat/view/components/onlineavatar.dart';
import 'package:chat/view/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import 'conversation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  SocketController socketController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SocketController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: IconButton(
                  onPressed: () {
                    Get.to(const Profile());
                  },
                  icon: const Icon(
                    Icons.person,
                    color: Colors.white,
                  )),
            )
          ],
          backgroundColor: Colors.indigo,
          leading: IconButton(
              onPressed: () {
                controller.logout();
                Get.off(const Home());
                sharedPreferences!.clear();
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              )),
          title: const Text(
            'Chat App',
            style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                  child: Text(
                'Chats',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              )),
              Tab(
                  child: Text(
                'Active Users',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              )),
            ],
          ),
        ),
        body: GetBuilder<SocketController>(
          builder: (controller) => TabBarView(
            controller: _tabController,
            children: [
              // Widget for displaying chats
              controller.chats.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 80,
                          ),
                          const Center(
                            child: Icon(
                              Icons.chat_bubble_outline_outlined,
                              size: 150,
                              color: Colors.grey,
                            ),
                          )
                              .animate()
                              .slideY(begin: -2, end: 0, curve: Curves.easeIn),
                          const SizedBox(
                            height: 40,
                          ),
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'You are not involved in any conversation. Start your first one now!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          )
                              .animate()
                              .slideX(begin: -2, end: 0, curve: Curves.easeIn),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.only(left: 20, top: 20, bottom: 10),
                          child: Text(
                            'Conversations you are involved in.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 5,
                            ),
                            itemCount: controller.chats.length,
                            itemBuilder: (context, index) {
                              var chat = controller.chats[index];
                              return ListTile(
                                trailing: Text(
                                    Services.calculateMembershipDuration(
                                        DateTime.parse(chat.lastsentat))),
                                leading: OnlineAvatar(
                                  imageUrl: 'assets/image/profilee.png',
                                  isOnline: controller.activeIDS
                                      .contains(chat.userId),
                                ),
                                title: Text(
                                  chat.userFirstName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.grey),
                                ),
                                subtitle: Text(
                                  chat.lastMessage,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                onTap: () {
                                  controller.userToText = User(
                                    userId: chat.userId,
                                    userFirstName: chat.userFirstName,
                                    userSecondName: chat.userSecondName,
                                    userEmail: chat.userEmail,
                                    userPassword: '',
                                    userCreatedAt:
                                        DateTime.parse(chat.userCreatedAt),
                                  );
                                  // controller.userOnlineStatus(
                                  //     controller.userToText!.userId);
                                  controller.updateOnlineStatus(chat.userId);

                                  controller.createConvo('lastmessage', 1);
                                  // controller.updateConvoId();
                                  Get.to(Conversation());
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
              // Widget for displaying active users
              controller.activeUsers.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 80,
                          ),
                          const Center(
                            child: Icon(
                              Icons.accessibility_new_rounded,
                              size: 150,
                              color: Colors.grey,
                            ),
                          )
                              .animate()
                              .slideY(begin: -2, end: 0, curve: Curves.easeIn),
                          const SizedBox(
                            height: 40,
                          ),
                          const Center(
                            child: Text(
                              'No active user you can chat with at this moment, please wait for someone to join!',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          )
                              .animate()
                              .slideX(begin: 2, end: 0, curve: Curves.easeIn),
                        ],
                      ),
                    )
                  : Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding:
                                EdgeInsets.only(left: 20, top: 20, bottom: 10),
                            child: Text(
                              'Active users',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: controller.activeUsers.length,
                              itemBuilder: (BuildContext context, int index) {
                                var user = socketController.activeUsers[index];
                                return ListTile(
                                  onTap: () {
                                    controller.userToText = user;
                                    controller.update();

                                    controller.createConvo('lastmessage', 1);
                                    // controller.updateConvoId();
                                    controller.userOnlineStatus(
                                        controller.userToText!.userId);
                                    Get.to(Conversation());
                                  },
                                  title: Text(
                                    user.userFirstName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  leading: OnlineAvatar(
                                      imageUrl: 'assets/image/profilee.png',
                                      isOnline: true),
                                  // Add onTap callback if you want to handle user selection
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
