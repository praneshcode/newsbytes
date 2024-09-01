import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:newsapp/constants/config_constants.dart';
import 'package:newsapp/models/news.dart';
import 'package:http/http.dart' as http;

class HeadlinesController {
  List<News>? newsList;
  List<News>? get getNewsList => newsList;

  late String message;
  String get getMessage => message;

  Future<void> fetchNews(
      {required String country, required String category}) async {
    String url = getUrl(country: country, category: category);

    final response = await http.get(Uri.parse(url));
    Map<String, dynamic> jsonData = json.decode(response.body);

    String status = jsonData['status'];
    if (status == 'ok') {
      message = 'ok';
      newsList = [];
      for (Map<String, dynamic> map in jsonData['articles']) {
        News news = News.fromMap(map);
        if (news.title == '[Removed]') {
          continue;
        }
        newsList!.add(news);
      }
    } else {
      debugPrint(
          'API status: $status, Code: ${jsonData["code"]}, Message: ${jsonData["message"]}');
    }

    // debugPrint(url);
  }

  String getUrl({required String country, required String category}) {
    final String randomApiKey = ConfigConstants
        .apiKeys[Random().nextInt(ConfigConstants.apiKeys.length)];

    return '${ConfigConstants.headlinesEndpoint}?country=$country&category=$category&pageSize=100&apikey=$randomApiKey';
  }
}
