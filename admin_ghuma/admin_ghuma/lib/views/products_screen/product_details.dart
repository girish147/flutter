import 'package:admin_ghuma/views/widgets/text_style.dart';
import 'package:admin_ghuma/const/const.dart';

class ProductDetails extends StatelessWidget {
  final dynamic data;
  const ProductDetails({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        title: boldText(text: "${data['p_name']}", color: fontGrey, size: 16.0),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VxSwiper.builder(
                autoPlay: true,
                height: 350,
                aspectRatio: 16 / 9,
                viewportFraction: 1.0,
                itemCount: data['p_imgs'].length,
                itemBuilder: (context, index) {
                  return Image.network(
                    data['p_imgs'][index],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                }),
            10.heightBox,
            //title and details section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  boldText(
                      text: '${data['p_name']}', color: fontGrey, size: 18.0),

                  10.heightBox,
                  Row(
                    children: [
                      normalText(
                          text: '${data['p_category']}',
                          color: fontGrey,
                          size: 16.0),
                      10.widthBox,
                      normalText(
                          text: ' - ${data['p_subcategory']}',
                          color: fontGrey,
                          size: 16.0),
                    ],
                  ),
                  10.heightBox,
                  //rating section
                  VxRating(
                    isSelectable: false,
                    value: double.parse(data['p_rating']),
                    onRatingUpdate: (value) {},
                    normalColor: textfieldGrey,
                    selectionColor: golden,
                    count: 5,
                    maxRating: 5,
                    size: 25,
                  ),
                  10.heightBox,
                  boldText(
                    text: '₹ ${data['p_price']}',
                    color: red,
                    size: 18.0,
                  ),

                  //color section
                  20.heightBox,
                  Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: boldText(text: 'Color', color: fontGrey),
                          ),
                          Row(
                            //21.55 #5
                            children: List.generate(
                              data['p_colors'].length,
                              (index) => VxBox()
                                  .size(40, 40)
                                  .roundedFull
                                  .color(Color(data['p_colors'][index])
                                      .withOpacity(1.0))
                                  .margin(
                                      const EdgeInsets.symmetric(horizontal: 4))
                                  .make()
                                  .onTap(() {}),
                            ),
                          ),
                        ],
                      ),
                      10.heightBox,

                      //quantity section
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: boldText(text: 'Quantity', color: fontGrey),
                          ),
                          normalText(
                              text: '${data['p_quantity']} Items',
                              color: fontGrey),
                        ],
                      ),
                    ],
                  ).box.white.padding(const EdgeInsets.all(8)).make(),
                  const Divider(),
                  //description
                  20.heightBox,
                  boldText(text: 'Description', color: fontGrey),

                  10.heightBox,
                  normalText(
                    text: "${data['p_desc']}",
                    color: fontGrey,
                  ),
                  30.heightBox,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
