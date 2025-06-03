import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/news_item.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsItem news;
  final Color Function(String) getCategoryColor;
  final String Function(DateTime?) getReadTimeText;

  const NewsDetailScreen({
    super.key,
    required this.news,
    required this.getCategoryColor,
    required this.getReadTimeText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF312E81), Color(0xFF7C3AED), Color(0xFFEC4899)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.arrow_back, color: Color(0xFF6B7280)),
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      'Haber Detayı',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category and read time
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: getCategoryColor(news.category),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                news.category,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (news.lastReadTime != null) ...[
                              SizedBox(width: 12),
                              Icon(
                                Icons.access_time,
                                color: Color(0xFF6B7280),
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                getReadTimeText(news.lastReadTime),
                                style: TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 20),

                        // Title
                        Text(
                          news.title,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 20),

                        // Add an image at the top of the content
                        if (news.imageUrl.isNotEmpty)
                          Image.network(
                            news.imageUrl,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        SizedBox(height: 20),

                        // Content
                        Text(
                          news.summary,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF6B7280),
                            height: 1.6,
                          ),
                        ),
                        SizedBox(height: 20),

                        // Add a share button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.share, color: Color(0xFF6B7280)),
                              onPressed: () {
                                // Share functionality (to be implemented)
                                print('Share button pressed');
                              },
                            ),
                          ],
                        ),

                        // Add a read more link
                        if (news.readMoreUrl != null &&
                            news.readMoreUrl!.isNotEmpty)
                          GestureDetector(
                            onTap: () async {
                              final url = news.readMoreUrl!;
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'URL açılamıyor: $url';
                              }
                            },
                            child: Text(
                              'Daha fazla oku',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
