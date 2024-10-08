import 'package:admin_ghuma/const/const.dart';
import 'package:admin_ghuma/services/store_services.dart';
import 'package:admin_ghuma/views/messages_screen/chat_screen.dart';
import 'package:admin_ghuma/views/widgets/loading_indicator.dart';
import 'package:admin_ghuma/views/widgets/text_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: purpleColor, // Replace with the color of the app bar
        iconTheme: const IconThemeData(color: white),
        title: boldText(text: messages, size: 16.0, color: white),
      ),
      body: StreamBuilder(
        stream: StoreServices.getMessages(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator(circleColor: white);
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(data.length, (index) {
                    var t = data[index]['created_on'] == null
                        ? DateTime.now()
                        : data[index]['created_on'].toDate();
                    var time = intl.DateFormat('h:mm a').format(t);
                    return ListTile(
                      onTap: () {
                        Get.to(() => const ChatScreen());
                      },
                      leading: const CircleAvatar(
                          backgroundColor: purpleColor,
                          child: Icon(
                            Icons.person,
                            color: white,
                          )),
                      title: boldText(
                          text: '${data[index]['sender_name']}',
                          color: fontGrey),
                      subtitle: normalText(
                          text: '${data[index]['last_msg']}', color: darkGrey),
                      trailing: normalText(text: time, color: darkGrey),
                    );
                  }),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
