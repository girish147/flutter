import 'package:admin_ghuma/const/const.dart';
import 'package:admin_ghuma/controllers/products_controller.dart';
import 'package:admin_ghuma/views/products_screen/components/product_dropdown.dart';
import 'package:admin_ghuma/views/products_screen/components/product_images.dart';
import 'package:admin_ghuma/views/widgets/custom_textfield.dart';
import 'package:admin_ghuma/views/widgets/loading_indicator.dart';
import 'package:admin_ghuma/views/widgets/text_style.dart';
import 'package:get/get.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductsController>();
    return Obx(() => Scaffold(
        backgroundColor: purpleColor,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: white),
          backgroundColor: purpleColor,
          title: boldText(text: 'Add Product', size: 16.0),
          actions: [
            controller.isLoading.value ? loadingIndicator(circleColor: white) : TextButton(
                onPressed: () async {
                  controller.isLoading(true);
                  await controller.uploadImages();
                  await controller.uploadProduct(context);
                  Get.back();
                },
                child: boldText(text: save, size: 16.0)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customTextField(
                    hint: "eg: Beauty Boxx",
                    label: "Product name",
                    controller: controller.pnameController),
                10.heightBox,
                customTextField(
                    hint: "eg: Nice Boox",
                    label: "Description",
                    isDesc: true,
                    controller: controller.pdescController),
                10.heightBox,
                customTextField(
                    hint: "eg: \$ 100",
                    label: "Price",
                    controller: controller.ppriceController),
                10.heightBox,
                customTextField(
                    hint: "eg: 20",
                    label: "Quantity",
                    controller: controller.pquantityController),
                10.heightBox,
                productDropdown("Category", controller.categoryList,
                    controller.categoryvalue, controller),
                10.heightBox,
                productDropdown("Subcategory", controller.subcategoryList,
                    controller.subcategoryvalue, controller),
                10.heightBox,
                const Divider(color: white),
                boldText(text: "Upload Product Images"),
                10.heightBox,
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      3,
                      (index) => controller.pImagesList[index] != null
                          ? Image.file(
                              controller.pImagesList[index],
                              height: 100,
                              width: 100,
                            ).onTap(() {
                              controller.pickImage(index, context);
                            })
                          : productImages(label: "${index + 1}").onTap(() {
                              controller.pickImage(index, context);
                            }),
                    ),
                  ),
                ),
                5.heightBox,
                normalText(text: "First image is main image", color: red),
                const Divider(color: white),
                10.heightBox,
                boldText(text: "Choose Product Color:"),
                10.heightBox,
                Obx(
                  () => Wrap(
                    spacing: 4.0,
                    runSpacing: 4.0,
                    children: List.generate(
                        9,
                        (index) => Stack(
                              alignment: Alignment.center,
                              children: [
                                VxBox()
                                    .color(Vx.randomPrimaryColor)
                                    .roundedFull
                                    .size(50, 50)
                                    .make()
                                    .onTap(() {
                                  controller.selectedColorIndex.value = index;
                                }),
                                controller.selectedColorIndex.value == index
                                    ? const Icon(Icons.done, color: white)
                                    : const SizedBox(),
                              ],
                            )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
