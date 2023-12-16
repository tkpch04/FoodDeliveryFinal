// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class GroceryItemTile extends StatelessWidget {
  final String itemName;
  final String itemPrice;
  final String imagePath;
  // ignore: prefer_typing_uninitialized_variables
  final color;
  void Function()? onPressed;
  final String description;
  int qty;

  GroceryItemTile({
    super.key,
    required this.itemName,
    required this.itemPrice,
    required this.imagePath,
    required this.color,
    required this.onPressed,
    required this.description,
    required this.qty,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color[100],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // item image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Image.asset(
                imagePath,
                //height: 64,
                height: 90,
              ),
            ),

            // item name
            Text(
              itemName,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            Text(
              description,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),

            MaterialButton(
              onPressed: onPressed,
              color: color,
              child: Text(
                'Rp. $itemPrice',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
