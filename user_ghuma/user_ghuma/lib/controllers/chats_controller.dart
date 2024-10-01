import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_ghuma/consts/consts.dart';
import 'package:user_ghuma/controllers/home_controller.dart';
import 'package:get/get.dart';

class ChatsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getChatId();
  }

  var chats = firestore.collection(chatsCollection);
  var friendName = Get.arguments[0];
  var friendId = Get.arguments[1];

  var senderName = Get.find<HomeController>().username;
  var currentId = currentUser!.uid;

  var msgController = TextEditingController();

  dynamic chatDocId;

  var isLoading = false.obs;

  getChatId() async {
    isLoading(true);

    // Query to check if a chat document exists
    await chats
        .where('users', isEqualTo: {friendId: null, currentId: null})
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) {
          if (snapshot.docs.isNotEmpty) {
            chatDocId = snapshot.docs.single.id;
          } else {
            chatDocId =
                null; // Set chatDocId to null if no chat document exists
          }
        });

    isLoading(false);
  }

  sendMsg(String msg) async {
    if (msg.trim().isNotEmpty) {
      // Handle new chat creation or existing chat update
      if (chatDocId == null) {
        await chats.add({
          'created_on': FieldValue.serverTimestamp(),
          'last_msg': msg,
          'users': {friendId: null, currentId: null},
          'toId': friendId,
          'fromId': currentId,
          'friend_name': friendName,
          'sender_name': senderName
        }).then((value) {
          chatDocId = value.id;
        });
      } else {
        await chats.doc(chatDocId).update({
          'created_on': FieldValue.serverTimestamp(),
          'last_msg': msg,
          'toId': friendId,
          'fromId': currentId,
        });
      }

      // Add the message to the messages collection
      await chats.doc(chatDocId).collection(messagesCollection).doc().set({
        'created_on': FieldValue.serverTimestamp(),
        'msg': msg,
        'uid': currentId,
      });

      // Clear the message controller after sending the message
      msgController.clear();

      // Trigger UI update after sending the message
      isLoading.toggle(); // Force a UI update by toggling loading state
      isLoading.toggle();
    }
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:emart_app/consts/consts.dart';
// import 'package:emart_app/controllers/home_controller.dart';
// import 'package:get/get.dart';

// class ChatsController extends GetxController {
//   @override
//   void onInit() {
//     // TODO: implement onInit
//     super.onInit();
//     getChatId();
//   }

//   var chats = firestore.collection(chatsCollection);
//   var friendName = Get.arguments[0];
//   var friendId = Get.arguments[1];

//   var senderName = Get.find<HomeController>().username;
//   var currentId = currentUser!.uid;

//   var msgController = TextEditingController();

//   dynamic chatDocId;

//   var isLoading = false.obs;

//   getChatId() async {
//     isLoading(true);
//     // Query to check if a chat document exists
//     await chats
//         .where('users', isEqualTo: {friendId: null, currentId: null})
//         .limit(1)
//         .get()
//         .then((QuerySnapshot snapshot) {
//           if (snapshot.docs.isNotEmpty) {
//             chatDocId = snapshot.docs.single.id;
//           } else {
//             chats.add({
//               'created_on': null,
//               'last_msg': '',
//               'users': {friendId: null, currentId: null},
//               'toId': '',
//               'fromId': '',
//               'friend_name': friendName,
//               'sender_name': senderName
//             }).then((value) {
//               {
//                 chatDocId = value.id;
//               }
//             });
//           }
//         });

//     isLoading(false);
//   }

//   sendMsg(String msg) async {
//     if (msg.trim().isNotEmpty) {
//       chats.doc(chatDocId).update({
//         'created_on': FieldValue.serverTimestamp(),
//         'last_msg': msg,
//         'toId': friendId,
//         'fromId': currentId,
//       });

//       chats.doc(chatDocId).collection(messagesCollection).doc().set({
//         'created_on': FieldValue.serverTimestamp(),
//         'msg': msg,
//         'uid': currentId,
//       });
//     }
//   }
// }
