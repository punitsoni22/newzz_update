import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../constant/c_colors.dart';
import '../../core/services/category_news.dart';
import 'models/show_category.dart';

class CategoryPage extends StatefulWidget {
  String name;

  CategoryPage({super.key, required this.name});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<ShowCategoryModel> showCategory = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    getNews();
  }

  getNews() async {
    CategoryNews categoryNews = CategoryNews();
    await categoryNews.getCategoryNews(widget.name.toLowerCase());
    showCategory = categoryNews.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.name,
              style: TextStyle(
                  color: CColors.primaryColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: showCategory.length,
          itemBuilder: (context, index) {
            return ShowCategory(
                title: showCategory[index].title!,
                desc: showCategory[index].description!,
                img: showCategory[index].urlToImage!);
          }),
    );
  }
}

class ShowCategory extends StatelessWidget {
  String img, desc, title;

  ShowCategory({required this.title, required this.desc, required this.img});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: CachedNetworkImage(
              imageUrl: img,
              width: MediaQuery.of(context).size.width,
              height: 200,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            title,
            maxLines: 2,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(desc),
        ],
      ),
    );
  }
}
