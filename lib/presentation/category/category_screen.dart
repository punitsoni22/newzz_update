import 'package:flutter/material.dart';
import 'package:newzz_update/constant/c_colors.dart';
import 'package:newzz_update/presentation/category/category_page.dart';

class CategoryScreen extends StatelessWidget {
  final image;
  final categoryName;

  const CategoryScreen(
      {super.key, required this.categoryName, required this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => CategoryPage(name: categoryName,)));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                image,
                width: 120,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: 60,
              width: 120,
              decoration: BoxDecoration(color: Colors.black38),
              child: Center(
                child: Text(
                  categoryName,
                  style: TextStyle(
                      color: CColors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
