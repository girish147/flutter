import 'package:user_ghuma/consts/consts.dart';
import 'package:user_ghuma/views/orders_screen/components/order_place_details.dart';
import 'package:user_ghuma/views/orders_screen/components/order_status.dart';

class OrdersDetails extends StatelessWidget {
  final dynamic data;
  const OrdersDetails({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: "Order Details"
            .text
            .color(darkFontGrey)
            .fontFamily(semibold)
            .make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              orderStatus(
                color: redColor,
                icon: Icons.done,
                title: "Order Placed",
                showDone: data['order_placed'],
              ),
              orderStatus(
                color: Colors.blue,
                icon: Icons.thumb_up,
                title: "Order Confirmed",
                showDone: data['order_confirmed'],
              ),
              orderStatus(
                color: Colors.green,
                icon: Icons.local_shipping_rounded,
                title: "Order on the way",
                showDone: data['order_on_delivery'],
              ),
              orderStatus(
                color: Colors.purple,
                icon: Icons.done_all_rounded,
                title: "Delivered",
                showDone: data['order_delivered'],
              ),
              const Divider(),
              10.heightBox,
              Column(
                children: [
                  orderPlaceDetails(
                    d1: data['order_code'],
                    d2: data['shipping_method'],
                    title1: "Order Code",
                    title2: "Shipping Method",
                  ),
                  orderPlaceDetails(
                    d1: data['order_date'],
                    d2: data['payment_method'],
                    title1: "Order date",
                    title2: "Payment Method",
                  ),
                  orderPlaceDetails(
                    d1: "Unpaid",
                    d2: "Order Placed",
                    title1: "Payment Status",
                    title2: "Delivery Status",
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Shipping Address".text.fontFamily(bold).make(),
                            "Name: ${data['order_by_name']}"
                                .text
                                .color(redColor)
                                .fontFamily(semibold)
                                .make(),
                            "Email: ${data['order_by_email']}"
                                .text
                                .color(redColor)
                                .fontFamily(semibold)
                                .make(),
                            "Address: ${data['order_by_address']}"
                                .text
                                .color(redColor)
                                .fontFamily(semibold)
                                .make(),
                            "City: ${data['order_by_city']}"
                                .text
                                .color(redColor)
                                .fontFamily(semibold)
                                .make(),
                            "State: ${data['order_by_state']}"
                                .text
                                .color(redColor)
                                .fontFamily(semibold)
                                .make(),
                            "Phone: ${data['order_by_phone']}"
                                .text
                                .color(redColor)
                                .fontFamily(semibold)
                                .make(),
                            "Pincode: ${data['order_by_postalcode']}"
                                .text
                                .color(redColor)
                                .fontFamily(semibold)
                                .make()
                          ],
                        ),
                        SizedBox(
                          width: 120,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "Total Amount".text.fontFamily(bold).make(),
                              "₹ ${data['total_amount']}"
                                  .text
                                  .color(redColor)
                                  .size(20)
                                  .fontFamily(bold)
                                  .make()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ).box.outerShadowMd.white.make(),
              //const Divider(),
              10.heightBox,
              "Ordered Product"
                  .text
                  .size(16)
                  .color(darkFontGrey)
                  .fontFamily(semibold)
                  .make(),
              10.heightBox,
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: List.generate(data['orders'].length, (index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      orderPlaceDetails(
                        title1: data['orders'][index]['title'],
                        title2: data['orders'][index]['tprice'],
                        d1: "${data['orders'][index]['qty']} x ",
                        d2: "Refundable",
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          width: 30,
                          height: 20,
                          color: Color(data['orders'][index]['color']),
                        ),
                      ),
                      const Divider(),
                    ],
                  );
                }).toList(),
              )
                  .box
                  .outerShadowMd
                  .white
                  .margin(const EdgeInsets.only(bottom: 4))
                  .make(),
              100.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
