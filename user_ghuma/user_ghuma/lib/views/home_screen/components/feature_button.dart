import 'package:user_ghuma/consts/consts.dart';
import 'package:user_ghuma/views/category_screen/category_details.dart';
import 'package:get/get.dart';

Widget featureButton({String? title, icon}) {
  return Row(
    children: [
      Image.asset(icon, width: 60, fit: BoxFit.fill),
      10.widthBox,
      title!.text.color(darkFontGrey).fontFamily(semibold).make(),
    ],
  )
      .box
      .width(200)
      .margin(const EdgeInsets.symmetric(horizontal: 4))
      .white
      .padding(const EdgeInsets.all(4))
      .roundedSM
      .outerShadowSm
      .make()
      .onTap(() {
    Get.to(() => CategoryDetails(title: title));
  });
}
