import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_ghuma/consts/consts.dart';
import 'package:user_ghuma/models/category_model.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class ProductController extends GetxController {
  var quantity = 0.obs;
  var colorIndex = 0.obs;
  var totalPrice = 0.obs;
  var subcat = <String>[].obs; // Make it an observable list
  var isFav = false.obs;
  getSubCategories(title) async {
    subcat.clear();
    final storageRef = FirebaseStorage.instance.ref();
    final fileRef = storageRef.child('category_model.json');
    final downloadUrl = await fileRef.getDownloadURL();
    final response = await http.get(Uri.parse(downloadUrl));

    final data = response.body;
    final decoded = categoryModelFromJson(data);
    final s =
        decoded.categories.where((element) => element.name == title).toList();
    for (var e in s[0].subcategory) {
      subcat.add(e);
      print("Subcategory added: $e"); // Debug line
    }
    // print("Subcategories: $subcat"); // Debug line
  }

  // getSubCategories(title) async {
  //   subcat.clear();
  //   var data = await rootBundle.loadString('lib/services/category_model.json');
  //   var decoded = categoryModelFromJson(data);
  //   var s =
  //       decoded.categories.where((element) => element.name == title).toList();
  //   for (var e in s[0].subcategory) {
  //     subcat.add(e);
  //   }
  // }

  changeColorIndex(index) {
    colorIndex.value = index;
  }

  increaseQuantity(totalQuantity) {
    if (quantity.value < totalQuantity) {
      quantity.value++;
    }
  }

  decreaseQuantity() {
    if (quantity.value > 0) {
      quantity.value--;
    }
  }

  calculateTotalPrice(price) {
    totalPrice.value = price * quantity.value;
  }

  addToCart(
      {title, img, sellername, color, qty, tprice, context, vendorID}) async {
    await firestore.collection(cartCollection).doc().set({
      'title': title,
      'img': img,
      'sellername': sellername,
      'color': color,
      'qty': qty,
      'vendor_id': vendorID,
      'tprice': tprice,
      'added_by': currentUser!.uid,
    }).catchError((error) {
      VxToast.show(context, msg: error.toString());
    });
  }

  resetValues() {
    totalPrice.value = 0;
    quantity.value = 0;
    colorIndex.value = 0;
    isFav.value = false;
  }

  addToWishlist(docId, context) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayUnion([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(true);
    VxToast.show(context, msg: 'Added to favorites');
  }

  removeFromWishlist(docId, context) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
    }, SetOptions(merge: true));

    isFav(false);
    VxToast.show(context, msg: 'Removed from favorites');
  }

  checkIfFav(data) async {
    if (data['p_wishlist'].contains(currentUser!.uid)) {
      isFav(true);
    } else {
      isFav(false);
    }
  }
}
