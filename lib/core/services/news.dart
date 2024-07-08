import 'dart:convert';
import 'package:newzz_update/presentation/artical/models/artical_model.dart';
import 'package:http/http.dart' as http;

class ArticleNews {
  List<ArticleModel> news = [];
  int _limit = 15;
  int _page = 1;

  Future<void> getNews() async {
    String url =
        "https://newsapi.org/v2/everything?q=apple&from=2024-06-15&to=2024-06-15&sortBy=popularity&page=$_page&pageSize=$_limit&apiKey=8e73c2a2af1f4eb5bfc170ca56e445f8";
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print('Response data: $jsonData'); // Print the raw response data

      if (jsonData['status'] == 'ok') {
        List<ArticleModel> fetchedNews = [];
        jsonData["articles"].forEach((element) {
          if (element["urlToImage"] != null && element["description"] != null) {
            ArticleModel articleModel = ArticleModel(
              author: element["author"],
              title: element["title"],
              description: element["description"],
              url: element["url"],
              urlToImage: element["urlToImage"],
              content: element["content"],
            );
            fetchedNews.add(articleModel);
          }
        });
        news = fetchedNews;
        print('Articles fetched: ${news.length}'); // Print the number of articles fetched
        _page++;
      } else {
        print('Error status in response: ${jsonData['status']}');
      }
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
    }
  }
}
