
import 'package:e_c/Models/item.dart';
import 'package:e_c/Store/storehome.dart';
import 'package:e_c/Widgets/customAppBar.dart';
import 'package:e_c/Widgets/myDrawer.dart';
import 'package:flutter/material.dart';


class ProductPage extends StatefulWidget {
  final ItemModel itemModel;
  ProductPage({this.itemModel});
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantityOfItem = 1;
  @override
  Widget build(BuildContext context) {
    Size sizeHomeS = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        drawer: MyDrawer(),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(15.0),
              width: sizeHomeS.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.network(widget.itemModel.thumbnailUrl),
                      ),
                      Container(
                        color: Colors.grey[300],
                        child: SizedBox(
                          height: 1.0,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(19.8),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.itemModel.title, style: boldTextStyle),
                          SizedBox(
                            height: 10,
                          ),
                          Text(widget.itemModel.longDescription,
                              style: boldTextStyle),
                          SizedBox(
                            height: 10,
                          ),
                          Text(r"$" + widget.itemModel.price.toString(),
                              style: boldTextStyle),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.8),
                    child: Center(
                      child: InkWell(
                        onTap: (){
                          checkItemInCart(widget.itemModel.shortInfo, context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  Colors.lightGreenAccent,
                                  Colors.pink,
                                ],
                                begin: FractionalOffset(0.0, 0.0),
                                end: FractionalOffset(1.0, 0.0),
                                stops: [0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                          width: sizeHomeS.width - 40.0,
                          height: 50.0,
                          alignment: Alignment.center,
                          child: Text(
                            'Add to Cart',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
