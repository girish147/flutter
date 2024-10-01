import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_ghuma/consts/consts.dart';
import 'package:user_ghuma/services/firestore_services.dart';
import 'package:user_ghuma/widgets_common/loading_indicator.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        title:
            "My Wishlist".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getWishlists(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: loadingIndicator());
          } else if (snapshot.data!.docs.isEmpty) {
            return "Not added Yet!".text.color(darkFontGrey).makeCentered();
          } else {
            var data = snapshot.data!.docs;
            return Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Image.network(
                      '${data[index]['p_imgs'][0]}',
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                    title: '${data[index]['p_name']}'
                        .text
                        .fontFamily(semibold)
                        .size(16)
                        .color(darkFontGrey)
                        .make(),
                    subtitle: "${data[index]['p_price']}"
                        .numCurrency
                        .text
                        .fontFamily(semibold)
                        .size(16)
                        .color(redColor)
                        .make(),
                    trailing: const Icon(Icons.favorite, color: redColor)
                        .onTap(() async {
                      await firestore
                          .collection(productsCollection)
                          .doc(data[index].id)
                          .set({
                        'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
                      }, SetOptions(merge: true));
                    }),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
