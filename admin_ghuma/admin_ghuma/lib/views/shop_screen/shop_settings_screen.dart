import 'package:admin_ghuma/const/const.dart';
import 'package:admin_ghuma/controllers/profile_controller.dart';
import 'package:admin_ghuma/views/widgets/custom_textfield.dart';
import 'package:admin_ghuma/views/widgets/loading_indicator.dart';
import 'package:admin_ghuma/views/widgets/text_style.dart';
import 'package:get/get.dart';

class ShopSettings extends StatelessWidget {
  const ShopSettings({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();
    return Obx(
      () => Scaffold(
        backgroundColor: purpleColor,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: white),
          //automaticallyImplyLeading: false,
          title: boldText(text: shopSettings, size: 16.0),
          actions: [
            controller.isLoading.value
                ? loadingIndicator(circleColor: white)
                : TextButton(
                    onPressed: () async {
                      controller.isLoading(true);
                      await controller.updateShop(
                        shopaddress: controller.shopAddressController.text,
                        shopname: controller.shopNameController.text,
                        shopmobile: controller.shopMobileController.text,
                        shopwebsite: controller.shopWebsiteController.text,
                        shopdesc: controller.shopDescController.text,
                      );
                      VxToast.show(context,
                          msg: "Shop Updated", position: VxToastPosition.top);
                    },
                    child: normalText(text: save, size: 16.0)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              customTextField(
                label: shopName,
                hint: nameHint,
                controller: controller.shopNameController,
              ),
              10.heightBox,
              customTextField(
                label: address,
                hint: shopAddressHint,
                controller: controller.shopAddressController,
              ),
              10.heightBox,
              customTextField(
                label: mobile,
                hint: shopMobileHint,
                controller: controller.shopMobileController,
              ),
              10.heightBox,
              customTextField(
                label: website,
                hint: shopWebsiteHint,
                controller: controller.shopWebsiteController,
              ),
              10.heightBox,
              customTextField(
                isDesc: true,
                label: description,
                hint: shopDescHint,
                controller: controller.shopDescController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
