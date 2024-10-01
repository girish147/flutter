import 'package:admin_ghuma/const/const.dart';
import 'package:admin_ghuma/services/store_services.dart';
import 'package:admin_ghuma/views/orders_screen/orders_screen.dart';
import 'package:admin_ghuma/views/products_screen/product_details.dart';
import 'package:admin_ghuma/views/products_screen/products_screen.dart';
import 'package:admin_ghuma/views/widgets/appbar_widget.dart';
import 'package:admin_ghuma/views/widgets/dashboard_button.dart';
import 'package:admin_ghuma/views/widgets/loading_indicator.dart';
import 'package:admin_ghuma/views/widgets/text_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(dashboard),
      body: StreamBuilder(
        stream: StoreServices.getProducts(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator(circleColor: purpleColor);
          } else {
            var data = snapshot.data!.docs;
            data = data.sortedBy((a, b) =>
                b['p_wishlist'].length.compareTo(a['p_wishlist'].length));
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      dashboardButton(context,
                              title: products,
                              count: "${data.length}",
                              icon: icProducts)
                          .onTap(() {
                        Get.to(() => const ProductsScreen());
                      }),
                      //gpt
                      StreamBuilder(
                        stream: StoreServices.getOrders(currentUser!.uid),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return loadingIndicator(circleColor: purpleColor);
                          } else {
                            var dataCount = snapshot.data!.docs;
                            int ordersCount = dataCount.length;
                            return dashboardButton(context,
                                    title: orders,
                                    count: '$ordersCount',
                                    icon: icOrders)
                                .onTap(() {
                              Get.to(() => const OrdersScreen());
                            });
                          }
                        },
                      )
//gpt-
                    ],
                  ),
                  10.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //gpt
                      StreamBuilder(
                        stream: StoreServices.getProducts(currentUser!.uid),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return loadingIndicator(circleColor: purpleColor);
                          } else {
                            var dataRating = snapshot.data!.docs;
                            double sum = 0;
                            for (var product in dataRating) {
                              var rating = double.parse(product[
                                  'p_rating']); // assuming p_rating is the field name for the rating
                              sum += rating;
                            }
                            double averageRating = sum / dataRating.length;
                            return dashboardButton(context,
                                title: rating,
                                count: averageRating.toStringAsFixed(
                                    1), // round to one decimal place
                                icon: icStar);
                          }
                        },
                      ),
//gpt-
                      // dashboardButton(context,
                      //     title: rating, count: 60, icon: icStar),

                      dashboardButton(context,
                          title: totalSales, count: 15, icon: icOrders),
                    ],
                  ),
                  10.heightBox,
                  const Divider(),
                  10.heightBox,
                  boldText(text: popular, color: fontGrey, size: 16.0),
                  20.heightBox,
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(
                        data.length,
                        (index) => data[index]['p_wishlist'].length == 0
                            ? const SizedBox()
                            : ListTile(
                                onTap: () {
                                  Get.to(
                                      () => ProductDetails(data: data[index]));
                                },
                                leading: Image.network(
                                  data[index]['p_imgs'][0],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                                title: boldText(
                                    text: '${data[index]['p_name']}',
                                    color: fontGrey,
                                    size: 16.0),
                                subtitle: normalText(
                                    text: '₹ ${data[index]['p_price']}',
                                    color: darkGrey),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      // body: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceAround,
      //         children: [
      //           dashboardButton(context,
      //               title: products, count: 60, icon: icProducts),
      //           dashboardButton(context,
      //               title: orders, count: 15, icon: icOrders),
      //         ],
      //       ),
      //       10.heightBox,
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceAround,
      //         children: [
      //           dashboardButton(context,
      //               title: rating, count: 60, icon: icStar),
      //           dashboardButton(context,
      //               title: totalSales, count: 15, icon: icOrders),
      //         ],
      //       ),
      //       10.heightBox,
      //       const Divider(),
      //       10.heightBox,
      //       boldText(text: popular, color: fontGrey, size: 16.0),
      //       20.heightBox,
      //       Expanded(
      //         child: ListView(
      //           physics: const BouncingScrollPhysics(),
      //           shrinkWrap: true,
      //           children: List.generate(
      //             3,
      //             (index) => ListTile(
      //               onTap: () {},
      //               leading: Image.asset(
      //                 imgProduct,
      //                 width: 100,
      //                 height: 100,
      //                 fit: BoxFit.cover,
      //               ),
      //               title: boldText(
      //                   text: 'Product name', color: fontGrey, size: 16.0),
      //               subtitle: normalText(text: '\$50.00', color: darkGrey),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
