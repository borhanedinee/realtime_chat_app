import 'package:chat/main.dart';
import 'package:chat/model/chat.dart';
import 'package:chat/model/user.dart';
import 'package:chat/model/message.dart';
import 'package:chat/view/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketController extends GetxController {
  User? user;
  User? userToText;
  List<User> activeUsers = [];

  bool showPassword = true;

  void updateShowPasswordState(){
    showPassword = !showPassword;
    update();
  }

  String typing = '';

  int currentConvoId = 0;

  List<Message> messages = [];

  List<Chat> chats = [];

  String? onlineStatus = '' ;
  List activeIDS = [];

  late IO.Socket socket;

  var passwordController = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var signUpEmailController = TextEditingController().obs;
  var signUpPasswordController = TextEditingController().obs;
  var firstnameController = TextEditingController().obs;
  var secondnameController = TextEditingController().obs;
  var messageController = TextEditingController().obs;

  @override
  void onInit() {
    connectToServer();
    super.onInit();
  }


  void updateOnlineStatus (data){
    if (activeIDS.contains(data)) {
      onlineStatus = 'online';
    } else {
      onlineStatus = 'offline';
    }
    update();
  }



  void connectToServer() {
    socket = IO.io('http://192.168.249.217:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected to server');
    });

    // socket.on('onlinestatuspart', (data) {
    //   print('vorhan' + data);
    //   if (data == 'online') {
    //     onlineStatus = 'online';
    //   } else {
    //     onlineStatus = 'offline';
    //   }
    //   update();
    // });

    socket.onDisconnect((_) {
      print('Disconnected from server');
    });

    // Add more event listeners or emit events as needed

    



    socket.on(
      'activeuserslist',
      (data) {
        activeUsers.clear();
        for (var element in data) {
          if (element['user_id'] != sharedPreferences?.getInt('userid')) {
            activeUsers.add(User.fromJson(element));
          }
        }
        for (var element in activeUsers) {
          activeIDS.add(element.userId);
        }
        update();
      },
    );

    socket.on('chats', (data) {
      chats.clear();
      List<Chat> cc = [];
      for (var element in data) {
        if (sharedPreferences!.getInt('userid') != element['user_id']) {
          cc.add(Chat.fromJson(element));
        }
      }
      chats = cc.reversed.toList();
      update();
    });

    socket.on('signupcheck', (data) {
      if (data == '') {
        Get.snackbar('Error', 'Something went wrong',
            backgroundColor: Colors.red);
      } else {
        Get.snackbar('Success', data['status'], backgroundColor: Colors.green);
        print(data);
        user = User.fromJson(data['response'][0]);
        mapsockets(user!.userId);
        Get.to(const HomeScreen());
      }
    });

    socket.on('updateconvoid', (data) {
      currentConvoId = data;
      update();
    });

    socket.on('updatemessageslist', (data) {
      messages.clear();
      List<Message> cc = [];
      for (var element in data['messages']) {
        cc.add(Message.fromJson(element));
      }
      messages = cc.reversed.toList();
      update();
    });

    socket.on('logincheck', (data) {
      if (data == 'invalid') {
        Get.snackbar('Error', 'Invalid email or password',
            backgroundColor: Colors.red);
      } else {
        Get.snackbar('Success', 'Logged in successfully',
            backgroundColor: Colors.green);
        user = User.fromJson(data[0]);
        sharedPreferences?.setInt('userid', user!.userId);
        sharedPreferences?.setString('useremail', user!.userEmail);
        sharedPreferences?.setString('userfirstname', user!.userFirstName);
        sharedPreferences?.setString('usersecondname', user!.userSecondName);
        sharedPreferences?.setString(
            'userjoinedat', user!.userCreatedAt.toString());
        mapsockets(sharedPreferences?.getInt('userid'));
        Get.off(const HomeScreen());
      }
    });

    socket.on('borhantyping', (data) {
      typing = 'typing';
      update();
    });

    socket.on('changetyping', (data) {
      typing = '';
      update();
    });

    socket.on('updateChatsListNow', (data) {
      chats.clear();
      List<Chat> cc = [];
      for (var element in data) {
        if (sharedPreferences!.getInt('userid') != element['user_id']) {
          
          cc.add(Chat.fromJson(element));
        }
      }
      chats = cc.reversed.toList();
      update();
    });
  }

  // fetching active users
  void fetchActiveUsers() {
    print('hi');
  }

  
  void userOnlineStatus(data){
    socket.emit('onlinestatus' , data);
  }

  void logout() {
    socket.emit('logout');
  }

  // signup
  void signup(data) {
    socket.emit('signup', data);
  }

  void checksignup() {}

  void sendMessage(data) {
    socket.emit('sendmessage', data);
    update();
  }

  void createConvo(lastmessage, seen) {
    socket.emit('createconvo', {
      'lastmessage': lastmessage,
      'islastmessageseen': seen,
      'usera': sharedPreferences?.getInt('userid'),
      'userb': userToText!.userId
    });
  }

  // mapping sockets
  void mapsockets(id) {
    socket.emit('mappingsockets', id);
  }

  // login
  void login(data) {
    socket.emit('login', data);
  }

  void checklogin() {}

  void updateUserToTextChatList(data) {
    socket.emit('changeusertotextchatlist', data);
  }

  void isUserTyping(data) {
    socket.emit('useristyping', data);
  }

  void changeUserToTextTypingValue(data) {
    socket.emit('nottypinganymore', data);
  }
}
