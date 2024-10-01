import 'package:admin_ghuma/controllers/products_controller.dart';
import 'package:admin_ghuma/services/store_services.dart';
import 'package:admin_ghuma/views/products_screen/add_product.dart';
import 'package:admin_ghuma/views/products_screen/product_details.dart';
import 'package:admin_ghuma/views/widgets/appbar_widget.dart';
import 'package:admin_ghuma/views/widgets/loading_indicator.dart';
import 'package:admin_ghuma/views/widgets/text_style.dart';
import 'package:admin_ghuma/const/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductsController());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: purpleColor,
        onPressed: () async {
          await controller.getCategories();
          controller.populateCategoryList();
          Get.to(() => const AddProduct());
        },
        child: const Icon(Icons.add, color: white),
      ),
      appBar: appbarWidget(products),
      body: StreamBuilder(
        stream: StoreServices.getProducts(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator(circleColor: purpleColor);
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(
                    data.length,
                    (index) => Card(
                      child: ListTile(
                        onTap: () {
                          Get.to(() => ProductDetails(data: data[index]));
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
                        subtitle: Row(
                          children: [
                            normalText(
                                text: '₹ ${data[index]['p_price']}',
                                color: darkGrey),
                            10.widthBox,
                            boldText(
                                text: data[index]['is_featured'] == true
                                    ? 'Featured'
                                    : "",
                                color: green,
                                size: 16.0),
                          ],
                        ),
                        trailing: VxPopupMenu(
                          arrowSize: Vx.dp20,
                          menuBuilder: () => Column(
                            children: List.generate(
                              popupMenuTitles.length,
                              (i) => Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      popupMenuIcons[i],
                                      color: data[index]['featured_id'] ==
                                                  currentUser!.uid &&
                                              i == 0
                                          ? green
                                          : darkGrey,
                                    ),
                                    10.widthBox,
                                    normalText(
                                        text: data[index]['featured_id'] ==
                                                    currentUser!.uid &&
                                                i == 0
                                            ? 'Remove Featured'
                                            : popupMenuTitles[i],
                                        color: darkGrey)
                                  ],
                                ).onTap(() {
                                  switch (i) {
                                    case 0:
                                      if (data[index]['is_featured'] == true) {
                                        controller
                                            .removeFeatured(data[index].id);
                                      } else {
                                        controller.addFeatured(data[index].id);
                                      }
                                      break;
                                    case 1:
                                      break;
                                    case 2:
                                      Get.defaultDialog(
                                        title: 'Confirm Removal',
                                        middleText:
                                            'Are you sure you want to remove this product?',
                                        backgroundColor: white,
                                        radius: 10,
                                        buttonColor: textfieldGrey,
                                        textConfirm: 'Yes',
                                        textCancel: 'No',
                                        confirmTextColor: const Color.fromARGB(
                                            255, 7, 128, 3),
                                        cancelTextColor: const Color.fromARGB(
                                            255, 233, 7, 7),
                                        onConfirm: () {
                                          controller
                                              .removeProduct(data[index].id);
                                        },
                                        onCancel: () {
                                          // Do nothing, just close the dialog
                                        },
                                      );
                                      break;
                                    // case 2:
                                    //   controller.removeProduct(data[index].id);
                                    //   break;
                                  }
                                }),
                              ),
                            ),
                          ).box.white.rounded.width(200).make(),
                          clickType: VxClickType.singleClick,
                          child: const Icon(Icons.movie_edit),
                        ),
                      ),
                    ),
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
