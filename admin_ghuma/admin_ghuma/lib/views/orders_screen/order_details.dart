import 'package:admin_ghuma/const/const.dart';
import 'package:admin_ghuma/controllers/orders_controller.dart';
import 'package:admin_ghuma/views/orders_screen/components/order_place.dart';
import 'package:admin_ghuma/views/widgets/our_button.dart';
import 'package:admin_ghuma/views/widgets/text_style.dart';
import 'package:get/get.dart';

class OrderDetails extends StatefulWidget {
  final dynamic data;
  const OrderDetails({super.key, this.data});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  var controller = Get.find<OrdersController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getOrders(widget.data);
    controller.confirmed.value = widget.data['order_confirmed'];
    controller.ontheway.value = widget.data['order_on_delivery'];
    controller.delivered.value = widget.data['order_delivered'];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          title: boldText(text: 'Order Details', size: 16.0, color: fontGrey),
        ),
        bottomNavigationBar: Visibility(
          visible: !controller.confirmed.value,
          child: SizedBox(
            height: 60,
            width: context.screenWidth,
            child: ourButton(
              color: green,
              onPress: () {
                controller.confirmed(true);
                controller.changeStatus(
                    title: 'order_confirmed',
                    status: true,
                    docID: widget.data.id);
              },
              title: 'Confirm Order',
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                //order delivery section
                Visibility(
                  visible: controller.confirmed.value,
                  child: Column(
                    children: [
                      boldText(
                          text: 'Order Status', size: 20.0, color: fontGrey),
                      SwitchListTile(
                        activeColor: green,
                        value: true,
                        onChanged: (value) {},
                        title: boldText(
                            text: 'Order Placed', size: 16.0, color: fontGrey),
                      ),
                      SwitchListTile(
                        activeColor: green,
                        value: controller.confirmed.value,
                        onChanged: (value) {
                          if (controller.confirmed.value) {
                            // ignore the new value if already confirmed
                            VxToast.show(context,
                                msg:
                                    'Already Confirmed, Please contact Ghuma to cancel',
                                bgColor: Vx.black,
                                textColor: Vx.white,
                                showTime: 3000);
                            return;
                          }
                          controller.confirmed.value = value;
                        },
                        title: boldText(
                            text: 'Confirmed', size: 16.0, color: fontGrey),
                      ),
                      // SwitchListTile(
                      //   activeColor: green,
                      //   value: controller.confirmed.value,
                      //   onChanged: (value) {
                      //     controller.confirmed.value = value;
                      //   },
                      //   title: boldText(
                      //       text: 'Confirmed', size: 16.0, color: fontGrey),
                      // ),
                      SwitchListTile(
                        activeColor: green,
                        value: controller.ontheway.value,
                        onChanged: (value) {
                          controller.ontheway.value = value;
                          controller.changeStatus(
                              title: 'order_on_delivery',
                              status: value,
                              docID: widget.data.id);
                        },
                        title: boldText(
                            text: 'On the way', size: 16.0, color: fontGrey),
                      ),
                      SwitchListTile(
                        activeColor: green,
                        value: controller.delivered.value,
                        onChanged: (value) {
                          controller.delivered.value = value;
                          controller.changeStatus(
                              title: 'order_delivered',
                              status: value,
                              docID: widget.data.id);
                        },
                        title: boldText(
                            text: 'Delivered', size: 16.0, color: fontGrey),
                      ),
                    ],
                  )
                      .box
                      .padding(const EdgeInsets.all(8))
                      .outerShadowMd
                      .white
                      .border(color: lightGrey)
                      .roundedSM
                      .make(),
                ),
                //order details section
                Column(
                  children: [
                    orderPlaceDetails(
                      d1: widget.data['order_code'],
                      d2: widget.data['shipping_method'],
                      title1: "Order Code",
                      title2: "Shipping Method",
                    ),
                    orderPlaceDetails(
                      d1: widget.data['order_date'],
                      // d1: data['order_date'],
                      d2: widget.data['payment_method'],
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
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // "Shipping Address".text.fontFamily(bold).make(),
                                boldText(
                                    text: 'Shipping Address',
                                    size: 16.0,
                                    color: purpleColor),
                                "Name: ${widget.data['order_by_name']}"
                                    .text
                                    .color(purpleColor)
                                    .make(),
                                "Email: ${widget.data['order_by_email']}"
                                    .text
                                    .color(purpleColor)
                                    .make(),
                                "Address: ${widget.data['order_by_address']}"
                                    .text
                                    .color(purpleColor)
                                    .make(),
                                "City: ${widget.data['order_by_city']}"
                                    .text
                                    .color(purpleColor)
                                    .make(),
                                "State: ${widget.data['order_by_state']}"
                                    .text
                                    .color(purpleColor)
                                    .make(),
                                "Phone: ${widget.data['order_by_phone']}"
                                    .text
                                    .color(purpleColor)
                                    .make(),
                                "Pincode: ${widget.data['order_by_postalcode']}"
                                    .text
                                    .color(purpleColor)
                                    .make()
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                boldText(
                                    text: 'Total Amount',
                                    size: 16.0,
                                    color: purpleColor),
                                boldText(
                                    text: "₹ ${widget.data['total_amount']}",
                                    size: 16.0,
                                    color: red),
                                // "Total Amount".text.fontFamily(bold).make(),
                                // "₹ ${data['total_amount']}"
                                //     .text
                                //     .color(redColor)
                                //     .size(20)
                                //     .fontFamily(bold)
                                //     .make()
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                    .box
                    .outerShadowMd
                    .white
                    .border(color: lightGrey)
                    .roundedSM
                    .make(),
                const Divider(),
                10.heightBox,
                boldText(text: 'Ordered product', size: 16.0, color: fontGrey),
                10.heightBox,
                ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: List.generate(controller.orders.length, (index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        orderPlaceDetails(
                          title1: "${controller.orders[index]['title']}",
                          title2: "₹ ${controller.orders[index]['tprice']}",
                          d1: "${controller.orders[index]['qty']} x ",
                          d2: "Refundable",
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            width: 30,
                            height: 20,
                            color: Color(controller.orders[index]['color']),
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
      ),
    );
  }
}
