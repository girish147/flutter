import 'dart:io';

import 'package:admin_ghuma/controllers/profile_controller.dart';
import 'package:admin_ghuma/views/widgets/custom_textfield.dart';
import 'package:admin_ghuma/views/widgets/loading_indicator.dart';
import 'package:admin_ghuma/views/widgets/text_style.dart';
import 'package:admin_ghuma/const/const.dart';
import 'package:get/get.dart';

class EditProfilescreen extends StatefulWidget {
  final String? username;
  const EditProfilescreen({super.key, this.username});

  @override
  State<EditProfilescreen> createState() => _EditProfilescreenState();
}

class _EditProfilescreenState extends State<EditProfilescreen> {
  var controller = Get.find<ProfileController>();
  @override
  void initState() {
    controller.nameController.text = widget.username!;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: purpleColor,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: white),
          //automaticallyImplyLeading: false,
          title: boldText(text: editProfile, size: 16.0),
          actions: [
            controller.isLoading.value
                ? loadingIndicator(circleColor: white)
                : TextButton(
                    onPressed: () async {
                      controller.isLoading(true);
                      //if image not selected
                      if (controller.profileImgPath.value.isNotEmpty) {
                        await controller.uploadProfileImage();
                      } else {
                        controller.profileImageLink =
                            controller.snapshotData['imageUrl'];
                      }
                      //if old password matches with data base
                      if (controller.snapshotData['password'] ==
                          controller.oldpassController.text) {
                        await controller.changeAuthPassword(
                          email: controller.snapshotData['email'],
                          password: controller.oldpassController.text,
                          newpassword: controller.newpassController.text,
                        );
                        await controller.updateProfile(
                            imgUrl: controller.profileImageLink,
                            name: controller.nameController.text,
                            password: controller.newpassController.text);
                        VxToast.show(context, msg: "Profile Updated");
                      } else if (controller
                              .oldpassController.text.isEmptyOrNull &&
                          controller.newpassController.text.isEmptyOrNull) {
                        await controller.updateProfile(
                            imgUrl: controller.profileImageLink,
                            name: controller.nameController.text,
                            password: controller.snapshotData['password']);
                        VxToast.show(context, msg: "Profile Updated");
                        // VxToast.show(context,
                        //     msg: "Old password does not match");
                        // controller.isLoading(false);
                      } else {
                        VxToast.show(context,
                            msg: "Old password does not match");
                        controller.isLoading(false);
                      }
                    },
                    child: normalText(text: save, size: 16.0)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              controller.snapshotData['imageUrl'] == '' &&
                      controller.profileImgPath.isEmpty
                  ? Image.asset(imgProduct, width: 100, fit: BoxFit.cover)
                      .box
                      .roundedFull
                      .clip(Clip.antiAlias)
                      .make()
                  //if data is not empty but controller is empty
                  : controller.snapshotData['imageUrl'] != '' &&
                          controller.profileImgPath.isEmpty
                      ? Image.network(
                          controller.snapshotData['imageUrl'],
                          width: 100,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make()

                      //if both are not empty
                      : Image.file(
                          File(controller.profileImgPath.value),
                          width: 100,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make(),
              // Image.asset(imgProduct, width: 150)
              //     .box
              //     .roundedFull
              //     .clip(Clip.antiAlias)
              //     .make(),
              10.heightBox,
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: white,
                ),
                onPressed: () {
                  controller.changeImage(context);
                },
                child: boldText(text: changeImage, color: fontGrey),
              ),
              10.heightBox,
              const Divider(),
              customTextField(
                  label: name,
                  hint: 'eg: Vendor Name',
                  controller: controller.nameController),
              30.heightBox,
              Align(
                alignment: Alignment.centerLeft,
                child: boldText(text: "Change Your password", size: 16.0),
              ),
              10.heightBox,
              customTextField(
                  label: password,
                  hint: passwordHint,
                  controller: controller.oldpassController),
              10.heightBox,
              customTextField(
                  label: confirmPass,
                  hint: passwordHint,
                  controller: controller.newpassController),
            ],
          ),
        ),
      ),
    );
  }
}
