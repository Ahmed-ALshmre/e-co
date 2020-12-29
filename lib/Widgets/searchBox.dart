import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Store/Search.dart';

class SearchBoxDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      InkWell(
        onTap: (){
          Route route =MaterialPageRoute(builder: (c)=>SearchProduct());
          Navigator.push(context, route);
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
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: 80.0,
          child: InkWell(
            child: Container(
              margin: EdgeInsets.only(right: 10,left: 10),
              width: MediaQuery.of(context).size.width,
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.search,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(
                    left: 8.0,
                  ),
                  child:Text('Search here'),

                  ),
                ],
              ),
            ),
          ),
        ),
      );

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
