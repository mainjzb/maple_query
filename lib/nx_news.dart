import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsListScreen extends StatefulWidget {
  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final NewsApi newsApi = NewsApi();
  late List<NewsItem> newsItems;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    final news = await newsApi.fetchNews();
    setState(() {
      newsItems = news;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
      ),
      body: newsItems != null
          ? ListView.builder(
              itemCount: newsItems.length,
              itemBuilder: (context, index) {
                final newsItem = newsItems[index];
                return ListTile(
                  title: Text(newsItem.title),
                  subtitle: Text(newsItem.summary),
                  leading: Image.network(newsItem.imageUrl),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class NewsItem {
  final int id;
  final String category;
  final String title;
  final String imageUrl;
  final String liveDate;
  final String updateDate;
  final String summary;

  NewsItem({
    required this.id,
    required this.category,
    required this.title,
    required this.imageUrl,
    required this.liveDate,
    required this.updateDate,
    required this.summary,
  });
}

class NewsApi {
  final String apiUrl =
      "https://nxl.nxfs.nexon.com/news/regions/1/10100/en-US/list.json";

  Future<List<NewsItem>> fetchNews() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // 解析数据并返回新闻列表
      return List<NewsItem>.from(data.map((item) => NewsItem(
            id: item["Id"],
            category: item["Category"],
            title: item["Title"],
            imageUrl: item["ImageThumbnail2"],
            liveDate: item["LiveDate"],
            updateDate: item["UpdateDate"],
            summary: item["Summary"],
          )));
    } else {
      throw Exception('Failed to load news');
    }
  }
}
