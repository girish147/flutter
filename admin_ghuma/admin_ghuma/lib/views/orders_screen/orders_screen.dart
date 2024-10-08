import 'package:admin_ghuma/services/store_services.dart';
import 'package:admin_ghuma/views/orders_screen/order_details.dart';
import 'package:admin_ghuma/views/widgets/appbar_widget.dart';
import 'package:admin_ghuma/const/const.dart';
import 'package:admin_ghuma/views/widgets/loading_indicator.dart';
import 'package:admin_ghuma/views/widgets/text_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
// import 'package:intl/intl.dart' as intl;

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // var controller = Get.put(OrdersController());
    return Scaffold(
      appBar: appbarWidget(orders),
      body: StreamBuilder(
        stream: StoreServices.getOrders(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator(circleColor: purpleColor);
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(
                    data.length,
                    (index) => ListTile(
                      onTap: () {
                        Get.to(() => OrderDetails(data: data[index]));
                      },
                      tileColor: textfieldGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: boldText(
                          text: '${data[index]['order_code']}',
                          color: purpleColor,
                          size: 16.0),
                      subtitle: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_month, color: fontGrey),
                              10.widthBox,
                              boldText(
                                  text: '${data[index]['order_date']}',
                                  color: fontGrey),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.payment, color: fontGrey),
                              10.widthBox,
                              boldText(text: unpaid, color: red),
                            ],
                          ),
                        ],
                      ),
                      trailing: boldText(
                          text: "${data[index]['total_amount']}\$",
                          color: purpleColor,
                          size: 16.0),
                    ).box.margin(const EdgeInsets.only(bottom: 4)).make(),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
