import 'package:user_ghuma/consts/consts.dart';
import 'package:user_ghuma/controllers/cart_controller.dart';
import 'package:user_ghuma/views/cart_screen/payment_method.dart';
import 'package:user_ghuma/widgets_common/custom_textfield.dart';
import 'package:user_ghuma/widgets_common/our_button.dart';
import 'package:get/get.dart';

class ShippingDetails extends StatelessWidget {
  const ShippingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Shipping Info"
            .text
            .fontFamily(semibold)
            .color(darkFontGrey)
            .make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ourButton(
          onPress: () {
            if (controller.addressController.text.isEmpty ||
                controller.cityController.text.isEmpty ||
                controller.stateController.text.isEmpty ||
                controller.postalcodeController.text.isEmpty ||
                controller.phoneController.text.isEmpty) {
              VxToast.show(context, msg: "Please fill all fields");
            } else {
              Get.to(() => const PaymentMethods());
            }
          },
          color: redColor,
          textColor: whiteColor,
          title: "Continue",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            customTextField(
                hint: "Address",
                isPass: false,
                title: "Address",
                controller: controller.addressController),
            customTextField(
                hint: "City",
                isPass: false,
                title: "City",
                controller: controller.cityController),
            customTextField(
                hint: "State",
                isPass: false,
                title: "State",
                controller: controller.stateController),
            customTextField(
                hint: "Postal Code",
                isPass: false,
                title: "Postal Code",
                controller: controller.postalcodeController),
            customTextField(
                hint: "Phone",
                isPass: false,
                title: "Phone",
                controller: controller.phoneController),
          ],
        ),
      ),
    );
  }
}
