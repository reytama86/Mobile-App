import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Categories extends StatefulWidget {
  
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final categoriesList = [
    'Top Recommended',
  ];
  int currentSelect = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 35,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => GestureDetector(
          onTap : () {
            setState(() {
              currentSelect = index;
            });
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.purple, width: 2))),  
              child: Text(
            categoriesList[index],
            style: TextStyle(
              color: Colors.purple, fontWeight: FontWeight.bold
            ),
            ),
          )
        ),
        separatorBuilder: (_, index) => SizedBox(width: 15),
        itemCount: categoriesList.length),
    );
  }
}