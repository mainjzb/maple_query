import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maple_query/news_detail.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<List<NewsItem>> newsItemsFuture = NewsApi.fetchNews();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
      ),
      body: FutureBuilder<List<NewsItem>>(
        future: newsItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final newsItems = snapshot.data!;
            return ListView.builder(
              itemCount: newsItems.length > 30 ? 30 : newsItems.length,
              itemBuilder: (context, index) {
                final newsItem = newsItems[index];
                // continer width inif
                return ListTile(
                  title: Text(newsItem.title),
                  subtitle: Text(newsItem.summary),
                  leading: SizedBox(
                    //width: 60,
                    child: Image.network(
                      newsItem.imageUrl,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            NewsPage(
                                "https://nxl.nxfs.nexon.com/news/items/${newsItems[index].id}"),
                        transitionDuration:
                            const Duration(milliseconds: 600), //动画时间为500毫秒
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          final tween = Tween(begin: begin, end: end);
                          final curvedAnimation = CurvedAnimation(
                            parent: animation,
                            curve: curve,
                          );

                          return SlideTransition(
                            position: tween.animate(curvedAnimation),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            );
          }
        },
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
  static const String apiUrl =
      "https://nxl.nxfs.nexon.com/news/regions/1/10100/en-US/list.json";

  static Future<List<NewsItem>> fetchNews() async {
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
