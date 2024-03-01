
import 'package:chat/controller/socketcontroller.dart';
import 'package:chat/main.dart';
import 'package:chat/services/srvices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Conversation extends StatefulWidget {
  Conversation({super.key});

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        endDrawer: GetBuilder<SocketController>(
          builder:(controller) => Drawer(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: IconButton(onPressed: () {
                            Get.back();
                          }, icon: Icon(Icons.arrow_back , color: Colors.indigo,)),
                        ),
                        SizedBox(height: 30,),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 53,
                                child: const CircleAvatar(
                                    radius: 50,
                                    backgroundImage: AssetImage('assets/image/profilee.png')),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                '${controller.userToText!.userFirstName} ${controller.userToText!.userSecondName}',
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold , color: Colors.grey),
                              ),
                              Text('${controller.userToText!.userFirstName} joined ${Services.calculateMembershipDuration(controller.userToText!.userCreatedAt)} ago'),
                            ],
                          ),
                        )
                        
                      ],
                    ),
            ),
          ),
        ),
        appBar: AppBar(
          
          actions: [
            Builder(
              builder: (context) {
                return IconButton(onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                }, icon: Icon(Icons.info , color: Colors.grey,));
              }
            )
          ],
          title: Builder(
            builder: (context) {
              return GestureDetector(
                onTap: () {
                  Scaffold.of(context).openEndDrawer();
                },
                child: GetBuilder<SocketController>(
                  builder: (controller) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.userToText!.userFirstName,
                        style:
                            const TextStyle(fontWeight: FontWeight.bold, fontSize: 24 ),
                      ),
                      Text(
                        controller.typing == ''
                            ? controller.onlineStatus!
                            : 'typing...',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey
                        ),
                      )
                    ],
                  ),
                  
                ),
              );
            }
          ),
        ),
        body: GetBuilder<SocketController>(
          builder: (controller) => controller.messages.isEmpty? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.center,
                        child: Text(
                          'This is your very first conversation with ${controller.userToText!.userFirstName}. \n please be polite :)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey),
                        ),
                      ),
                  ): Padding(
            padding:
                const EdgeInsets.only(right: 10, left: 10, bottom: 80, top: 10),
            child: ListView.separated(
              reverse: true,
              itemCount: controller.messages.length,
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 5,
                );
              },
              itemBuilder: (context, index) {
                var message = controller.messages[index];
                return message.sender == sharedPreferences?.getInt('userid')
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.only(left: 80),
                          constraints:
                              const BoxConstraints(maxWidth: double.infinity),
                          decoration: BoxDecoration(
                            color: Colors.indigo[800],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Text(
                            message.content,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 86, 85, 85),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Text(
                              message.content,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
              },
            ),
          ),
        ),
        bottomSheet: GetBuilder<SocketController>(
          builder: (controller) => Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 7, left: 7),
            child: Card(
              color: Colors.indigo.withOpacity(0.1),
              child: Container(
                decoration: const BoxDecoration(
      
                    // boxShadow: [BoxShadow(blurRadius: 80, color: Colors.black)]
                    //
                    ),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.messageController.value,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 7),
                          fillColor: Colors.indigo.withOpacity(0.4),
                          border: InputBorder.none,
                          hintText: "Type your message...",
                        ),
                        onChanged: (value) {
                          if (controller.messageController.value.text == '') {
                            controller.changeUserToTextTypingValue({
                              'conversationid': controller.currentConvoId,
                              'sender': sharedPreferences?.getInt('userid'),
                            });
                            controller.update();
                          } else {
                            controller.isUserTyping({
                              'conversationid': controller.currentConvoId,
                              'sender': sharedPreferences?.getInt('userid'),
                            });
                            controller.update();
                          }
                        },
                        onSubmitted: (value) {
                          if (value != '') {
                            controller.changeUserToTextTypingValue({
                            'conversationid': controller.currentConvoId,
                            'sender': sharedPreferences?.getInt('userid'),
                          });
                          controller.sendMessage({
                            'sender': sharedPreferences?.getInt('userid'),
                            'conversationid': controller.currentConvoId,
                            'content': value
                          });
      
                          controller.updateUserToTextChatList({
                            'conversationid': controller.currentConvoId,
                            'sender': sharedPreferences?.getInt('userid'),
                          });
      
                          controller.messageController.value.clear();
                          }
                        },
                      ),
                    ),
                    Visibility(
                      visible: controller.messageController.value.text != '',
                      child: IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Colors.indigo,
                        ),
                        onPressed: () {
                          // Send message when send button is pressed
      
                          controller.changeUserToTextTypingValue({
                            'conversationid': controller.currentConvoId,
                            'sender': sharedPreferences?.getInt('userid'),
                          });
                          controller.sendMessage({
                            'sender': sharedPreferences?.getInt('userid'),
                            'conversationid': controller.currentConvoId,
                            'content': controller.messageController.value.text
                          });
                          controller.updateUserToTextChatList({
                            'conversationid': controller.currentConvoId,
                            'sender': sharedPreferences?.getInt('userid'),
                          });
                          controller.messageController.value.clear();
                          controller.update();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
