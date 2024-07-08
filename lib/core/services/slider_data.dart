import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newzz_update/presentation/carouselSlider/model/slider_model.dart';

class SliderNews {
  List<SliderModel> sliderNews = [];

  Future<void> getSlider() async {
    String url = "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=8e73c2a2af1f4eb5bfc170ca56e445f8";
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print('Response data: $jsonData'); // Print the raw response data

      if (jsonData['status'] == 'ok') {
        jsonData["articles"].forEach((element) {
          if (element["urlToImage"] != null && element["description"] != null) {
            SliderModel articleModel = SliderModel(
              title: element["title"],
              url: element["url"],
              urlToImage: element["urlToImage"],
            );
            sliderNews.add(articleModel);
          }
        });
        print('Articles fetched: ${sliderNews.length}'); // Print the number of articles fetched
      } else {
        print('Error status in response: ${jsonData['status']}');
      }
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
    }
  }
}
