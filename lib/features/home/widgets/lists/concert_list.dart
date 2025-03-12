import 'package:flutter/material.dart';
import '../../models/concert_model.dart';
import '../items/concert_item.dart';

class ConcertList extends StatelessWidget {
  final List<ConcertModel> concerts;

  const ConcertList({super.key, required this.concerts});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: concerts.length,
        itemBuilder: (context, index) {
          return ConcertItem(concert: concerts[index]);
        },
      ),
    );
  }
}
