import 'package:admin_ghuma/const/const.dart';
import 'package:admin_ghuma/controllers/products_controller.dart';
import 'package:admin_ghuma/views/widgets/text_style.dart';
import 'package:get/get.dart';

Widget productDropdown(
    hint, List<String> list, dropvalue, ProductsController controller) {
  return Obx(
    () => Container(
      decoration: BoxDecoration(
        border: Border.all(color: darkGrey),
        borderRadius: BorderRadius.circular(10), // optional
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          dropdownColor: fontGrey,
          padding: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(20),
          hint: normalText(text: '$hint', size: 14.0),
          value: dropvalue.value == "" ? null : dropvalue.value,
          isExpanded: true,
          items: list.map((e) {
            return DropdownMenuItem(
              child: e.toString().text.make(),
              value: e,
            );
          }).toList(),
          onChanged: (newValue) {
            if (hint == "Category") {
              controller.subcategoryvalue.value = "";
              controller.populateSubcategoryList(newValue.toString());
            }
            dropvalue.value = newValue.toString();
          },
          style: const TextStyle(color: white),
        ),
      )
          .box
          .white
          .roundedSM
          .color(purpleColor)
          .padding(const EdgeInsets.symmetric(horizontal: 4))
          .make(),
    ),
  );
}
