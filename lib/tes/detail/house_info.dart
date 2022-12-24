import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HouseInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              MenuInfo(
                imageUrl: 'assets/icons/bedroom.svg',
                content: 'pelayanan spesial\nsupport big family'),
              MenuInfo(
                imageUrl: 'assets/icons/bathroom.svg',
                content: 'free wifi\navailable TV mini '),
            ],
          ),
          SizedBox(height: 10),
           Row(
            children: [
              MenuInfo(
                imageUrl: 'assets/icons/kitchen.svg',
                content: 'tercover makan\nMinuman paket keluarga'),
              MenuInfo(
                imageUrl: 'assets/icons/parking.svg',
                content: '7 tempat duduk\n+tempat duduk anak'),
            ],
          ),
        ],
      ),
    );
    
  }
}

class HouseInfo2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              MenuInfo(
                imageUrl: 'assets/icons/bedroom.svg',
                content: 'pelayanan spesial\nsupport big family'),
              MenuInfo(
                imageUrl: 'assets/icons/bathroom.svg',
                content: 'free wifi'),
            ],
          ),
          SizedBox(height: 10),
           Row(
            children: [
              MenuInfo(
                imageUrl: 'assets/icons/kitchen.svg',
                content: 'tercover makan\nMinuman'),
              MenuInfo(
                imageUrl: 'assets/icons/parking.svg',
                content: '5 tempat duduk\n+tempat duduk anak'),
            ],
          ),
        ],
      ),
    );
    
  }
}

class MenuInfo extends StatelessWidget {
  final String imageUrl;
  final String content;
  const MenuInfo({Key? key,
  required this.imageUrl,
  required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: Row(children: [
          SvgPicture.asset(imageUrl),
          SizedBox(width: 20),
          Text(content,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12),)
        ],),
      ),
    );
  }
}