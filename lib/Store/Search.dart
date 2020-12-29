
import 'package:e_c/Models/item.dart';
import 'package:e_c/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Widgets/customAppBar.dart';

class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => new _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  Future<QuerySnapshot> listQuery;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          bottom: PreferredSize(
            child: sizedWidth(),
            preferredSize: Size(56.0, 56.0),
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: listQuery,
          builder: (context, snapShout) {
            return snapShout.hasData
                ? ListView.builder(
                    itemCount: snapShout.data.documents.length,
                    itemBuilder: (context, index) {
                      ItemModel model = ItemModel.fromJson(
                          snapShout.data.documents[index].data);
                      return sourceInfo(model, context);
                    })
                : Center(
                    child: Text('Not Data new'),
                  );
          },
        ),
      ),
    );
  }

  Widget sizedWidth() {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 80.0,
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
      child: Container(
        width: MediaQuery.of(context).size.width - 40.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.search,
                color: Colors.blueGrey,
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: TextField(
                  onChanged: (value) {
                    startSearch(value);
                  },
                  decoration:
                      InputDecoration.collapsed(hintText: "Search here"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: missing_return
  Future startSearch(String query) async {
    listQuery = Firestore.instance
        .collection('items')
        .where('shortInfo', isGreaterThanOrEqualTo: query)
        .getDocuments();
  }
}
