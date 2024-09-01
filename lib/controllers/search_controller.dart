import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:newsapp/constants/config_constants.dart';
import 'package:newsapp/models/news.dart';
import 'package:http/http.dart' as http;

class SearchController {
  List<News>? newsList;
  List<News>? get getNewsList => newsList;

  late String message;
  String get getMessage => message;

  Future<void> fetchNews(
      {required String keyword, required String sortBy}) async {
    String url = getUrl(keyword: keyword, sortBy: sortBy);
    if (keyword.isEmpty) {
      message = 'empty keyword';
      return;
    }

    final response = await http.get(Uri.parse(url));
    Map<String, dynamic> jsonData = json.decode(response.body);

    String status = jsonData['status'];
    if (status == 'ok') {
      int totalResults = jsonData['totalResults'];
      if (totalResults > 0) {
        message = 'success';
        newsList = [];
        for (Map<String, dynamic> map in jsonData['articles']) {
          News news = News.fromMap(map);
          if (news.title == '[Removed]') {
            continue;
          }
          newsList!.add(news);
        }
      } else {
        message = 'no result';
        debugPrint('No results found');
      }
    } else {
      message = 'error';
      debugPrint(
          'API status: $status, Code: ${jsonData["code"]}, Message: ${jsonData["message"]}');
    }

    // debugPrint(url);
  }

  String getUrl({required String keyword, required String sortBy}) {
    final String randomApiKey = ConfigConstants
        .apiKeys[Random().nextInt(ConfigConstants.apiKeys.length)];

    return '${ConfigConstants.everythingEndpoint}?q=$keyword&sortBy=$sortBy&pageSize=100&apikey=$randomApiKey';
  }
}
