import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/news_item.dart';

class NewsCard extends StatefulWidget {
  final NewsItem news;
  final double dragOffset;
  final Color Function(String) getCategoryColor;
  final Function(bool) onBookmarkChanged;
  final List<NewsItem> allNews;

  const NewsCard({
    super.key,
    required this.news,
    required this.dragOffset,
    required this.getCategoryColor,
    required this.onBookmarkChanged,
    required this.allNews,
  });

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  String getReadTimeText(DateTime? lastReadTime) {
    if (lastReadTime == null) return 'Henüz okunmadı';

    final difference = DateTime.now().difference(lastReadTime);
    if (difference.inMinutes < 1) {
      return 'Az önce okundu';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} dakika önce okundu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} saat önce okundu';
    } else {
      return '${difference.inDays} gün önce okundu';
    }
  }

  int _getTrendingRank() {
    List<NewsItem> trendingNews = NewsItem.getTrendingNews(widget.allNews);
    for (int i = 0; i < trendingNews.length; i++) {
      if (trendingNews[i].id == widget.news.id) {
        return i + 1; // Return 1-based rank (1, 2, 3)
      }
    }
    return 0; // Should not happen if news is trending
  }

  Widget _buildGradientBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.news.gradientColors,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 60,
      height: 500,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card image area
              Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                      child: Image.network(
                        widget.news.imageUrl,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Stack(
                            children: [
                              _buildGradientBackground(),
                              Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return _buildGradientBackground();
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.5),
                            Colors.transparent,
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: widget.getCategoryColor(
                                widget.news.category,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              widget.news.category,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (widget.news.isTrendingIn(widget.allNews)) ...[
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('🔥', style: TextStyle(fontSize: 10)),
                                  SizedBox(width: 4),
                                  Text(
                                    'Top ${_getTrendingRank()}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (widget.news.lastReadTime != null)
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.white.withOpacity(0.9),
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              getReadTimeText(widget.news.lastReadTime),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // Card content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.news.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        widget.news.summary,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                          height: 1.5,
                        ),
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Share button on the left
                          GestureDetector(
                            onTap: () async {
                              final text =
                                  '${widget.news.title}\n\n${widget.news.summary}';
                              await Clipboard.setData(
                                  ClipboardData(text: text));
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Panoya kopyalandı'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.share,
                                color: Color(0xFF6B7280),
                                size: 20,
                              ),
                            ),
                          ),
                          // Bookmark button on the right
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                widget.news.isBookmarked =
                                    !widget.news.isBookmarked;
                                widget.onBookmarkChanged(
                                    widget.news.isBookmarked);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                widget.news.isBookmarked
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                color: widget.news.isBookmarked
                                    ? Color(0xFF7C3AED)
                                    : Color(0xFF6B7280),
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Swipe indicators
          if (widget.dragOffset > 50)
            Container(
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Transform.rotate(
                  angle: 0.2,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(Icons.menu_book, color: Colors.white, size: 32),
                  ),
                ),
              ),
            ),
          if (widget.dragOffset < -50)
            Container(
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Transform.rotate(
                  angle: -0.2,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 32),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
