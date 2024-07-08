import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constant/c_colors.dart';
import '../../core/services/data.dart';
import '../../core/services/news.dart';
import '../../core/services/slider_data.dart';
import '../artical/artical_screen.dart';
import '../artical/models/artical_model.dart';
import '../carouselSlider/model/slider_model.dart';
import '../category/category_screen.dart';
import '../category/models/category_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CategoryModel> categories = [];
  List<SliderModel> sliders = [];
  List<ArticleModel> articles = [];
  int activeIndex = 0;
  bool _loading = true;
  bool _loadingMore = false;
  final ScrollController _scrollController = ScrollController();
  final ArticleNews articleNews = ArticleNews();

  @override
  void initState() {
    super.initState();
    fetchSliderData();
    fetchArticleData();
    categories = getCategory();

    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_loadingMore) {
      print("Fetching more articles...");
      fetchMoreArticles();
    }
  }

  fetchSliderData() async {
    SliderNews sliderNews = SliderNews();
    await sliderNews.getSlider();

    setState(() {
      sliders = sliderNews.sliderNews;
    });
  }

  fetchArticleData() async {
    await articleNews.getNews();

    setState(() {
      articles = articleNews.news;
      _loading = false;
    });
    print(
        'Articles in HomeScreen: ${articles.length}'); // Print the number of articles in HomeScreen
  }

  fetchMoreArticles() async {
    setState(() {
      _loadingMore = true;
    });

    await articleNews.getNews();

    setState(() {
      articles.addAll(articleNews.news);
      _loadingMore = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Newzz"),
            Text(
              "Update",
              style: TextStyle(
                  color: CColors.primaryColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        controller: _scrollController,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return CategoryScreen(
                          categoryName: categories[index].categoryName,
                          image: categories[index].image,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Breaking News!",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "View All",
                          style: TextStyle(
                              color: CColors.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  CarouselSlider.builder(
                    itemCount: sliders.length,
                    itemBuilder: (context, index, realIndex) {
                      String? img = sliders[index].urlToImage;
                      String? namee = sliders[index].title;
                      return buildImage(img!, index, namee!);
                    },
                    options: CarouselOptions(
                        height: 200,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            activeIndex = index;
                          });
                        }),
                  ),
                  SizedBox(height: 10),
                  buildIndicator(),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Trending News!",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "View All",
                          style: TextStyle(
                              color: CColors.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: articles.length + 1,
                    // Add one more for the loading indicator
                    itemBuilder: (context, index) {
                      if (index == articles.length) {
                        return _loadingMore
                            ? Center(child: CircularProgressIndicator())
                            : SizedBox.shrink();
                      }
                      return ArticleScreen(
                        articleUrl: articles[index].url!,
                        title: articles[index].title!,
                        decs: articles[index].description!,
                        imgUrl: articles[index].urlToImage!,
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildImage(String image, int index, String name) => Container(
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                image,
                height: 250,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              margin: EdgeInsets.only(top: 150),
              decoration: BoxDecoration(color: Colors.black38),
              child: Center(
                child: Text(
                  name,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildIndicator() => AnimatedSmoothIndicator(
        effect: SlideEffect(dotHeight: 10, dotWidth: 10),
        activeIndex: activeIndex,
        count: sliders.length,
      );
}
