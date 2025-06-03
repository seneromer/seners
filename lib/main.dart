import 'package:flutter/material.dart';

// Model importları
import 'models/news_item.dart';

// Veri importları
import 'data/news_data.dart';

// Widget importları
import 'widgets/news_card.dart';
import 'widgets/news_detail.dart';

void main() {
  runApp(BuneyaApp());
}

class BuneyaApp extends StatelessWidget {
  const BuneyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'buneya',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: Color(0xFF312E81),
      ),
      home: NewsSwipeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NewsSwipeScreen extends StatefulWidget {
  const NewsSwipeScreen({super.key});

  @override
  _NewsSwipeScreenState createState() => _NewsSwipeScreenState();
}

class _NewsSwipeScreenState extends State<NewsSwipeScreen>
    with TickerProviderStateMixin {
  int currentIndex = 0;
  double dragOffset = 0.0;
  bool isDragging = false;
  late AnimationController _animationController;
  List<NewsItem> deletedNews = []; // Silinen kartları tutacak liste
  List<NewsItem> bookmarkedNews = []; // Kaydedilen kartları tutacak liste
  String selectedCategory = 'buneya'; // Seçili kategori

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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

  void handleSwipe(bool isLike) {
    if (isLike) {
      // setState içinde güncelleme yaparak UI'ın yenilenmesini sağla
      setState(() {
        // Kart açıldığında zamanı güncelle ve okuma sayısını artır
        newsData[currentIndex].lastReadTime = DateTime.now();
        newsData[currentIndex].viewCount++;
        print(
            'Haber ${newsData[currentIndex].id}: viewCount = ${newsData[currentIndex].viewCount}');
        print(
            'Trending durumu: ${newsData[currentIndex].isTrendingIn(newsData)}');

        // En fazla okunan 3 haberi göster
        List<NewsItem> trendingNews = NewsItem.getTrendingNews(newsData);
        print(
            'Trending haberler: ${trendingNews.map((n) => 'ID:${n.id}(${n.viewCount})').join(', ')}');
      });

      // Sağa kaydırıldıysa detay sayfasına git
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsDetailScreen(
            news: newsData[currentIndex],
            getCategoryColor: getCategoryColor,
            getReadTimeText: getReadTimeText,
          ),
        ),
      ).then((_) {
        // Detay sayfasından dönüldüğünde sonraki karta geç
        setState(() {
          currentIndex = (currentIndex + 1) % newsData.length;
          dragOffset = 0;
          _animationController.forward().then((_) {
            _animationController.reset();
          });
        });
      });
      return;
    }

    setState(() {
      // Sola kaydırıldıysa veya çöp kutusu butonuna tıklandıysa
      deletedNews.add(newsData[currentIndex]);

      // Eğer son karttaysak ve yeni tura başlıyorsak
      if (currentIndex == newsData.length - 1) {
        deletedNews.clear(); // Çöp kutusunu temizle
      }

      currentIndex = (currentIndex + 1) % newsData.length;
      dragOffset = 0;
    });
    _animationController.forward().then((_) {
      _animationController.reset();
    });
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case 'Technology':
        return Color(0xFFA855F7);
      case 'Environment':
        return Color(0xFF10B981);
      case 'Science':
        return Color(0xFF3B82F6);
      case 'Business':
        return Color(0xFFF97316);
      default:
        return Color(0xFF6B7280);
    }
  }

  // Drawer menüsünü oluşturan metod
  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: Color(0xFF312E81),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'buneya',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Burası dolacak',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.white),
              title: Text('Anasayfa', style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() => selectedCategory = 'NewsSwipe');
                Navigator.pop(context);
              },
            ),
            ExpansionTile(
              title: Text(
                'Kategoriler',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(Icons.category, color: Colors.white),
              backgroundColor: Color(0xFF312E81),
              collapsedIconColor: Colors.white,
              iconColor: Colors.white,
              initiallyExpanded: true,
              children: [
                ListTile(
                  leading: Icon(Icons.computer, color: Colors.white),
                  title:
                      Text('Teknoloji', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    setState(() => selectedCategory = 'Teknoloji');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.eco, color: Colors.white),
                  title: Text('Çevre', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    setState(() => selectedCategory = 'Çevre');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.science, color: Colors.white),
                  title: Text('Bilim', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    setState(() => selectedCategory = 'Bilim');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.business, color: Colors.white),
                  title:
                      Text('İş Dünyası', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    setState(() => selectedCategory = 'İş Dünyası');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            Divider(color: Colors.white24),
            ListTile(
              leading: Icon(Icons.info_outline, color: Colors.white),
              title: Text('Hakkında', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentNews = newsData[currentIndex];

    return Scaffold(
      drawer: _buildDrawer(),
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
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Drawer menü butonu
                        Builder(
                          builder: (context) => IconButton(
                            icon: Icon(Icons.menu, color: Colors.white),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: currentNews.isTrendingIn(newsData)
                                  ? [Color(0xFFFF4444), Color(0xFFFF6B6B)]
                                  : [Color(0xFFEC4899), Color(0xFF7C3AED)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            currentNews.isTrendingIn(newsData)
                                ? Icons.whatshot
                                : Icons.trending_up,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          selectedCategory,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${currentIndex + 1} / ${newsData.length}',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),

              // Card Area
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background cards
                      if (currentIndex + 1 < newsData.length)
                        Transform.scale(
                          scale: 0.95,
                          child: Container(
                            width: MediaQuery.of(context).size.width - 60,
                            height: 500,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      if (currentIndex + 2 < newsData.length)
                        Transform.scale(
                          scale: 0.9,
                          child: Container(
                            width: MediaQuery.of(context).size.width - 60,
                            height: 500,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),

                      // Main card
                      GestureDetector(
                        onPanStart: (details) {
                          setState(() {
                            isDragging = true;
                          });
                        },
                        onPanUpdate: (details) {
                          setState(() {
                            dragOffset += details.delta.dx;
                          });
                        },
                        onPanEnd: (details) {
                          if (dragOffset.abs() > 100) {
                            handleSwipe(dragOffset > 0);
                          } else {
                            setState(() {
                              dragOffset = 0;
                            });
                          }
                          setState(() {
                            isDragging = false;
                          });
                        },
                        child: Transform.translate(
                          offset: Offset(dragOffset, 0),
                          child: Transform.rotate(
                            angle: dragOffset * 0.001,
                            child: NewsCard(
                              news: currentNews,
                              dragOffset: dragOffset,
                              getCategoryColor: getCategoryColor,
                              allNews: newsData,
                              onBookmarkChanged: (isBookmarked) {
                                setState(() {
                                  // Eğer kart işaretleniyorsa ve listede yoksa ekle
                                  if (isBookmarked) {
                                    if (!bookmarkedNews.contains(currentNews)) {
                                      bookmarkedNews.add(currentNews);
                                    }
                                  } else {
                                    // İşaret kaldırılıyorsa hem kartı hem de bookmarkedNews'den kaldır
                                    currentNews.isBookmarked = false;
                                    bookmarkedNews.removeWhere(
                                      (item) => item.id == currentNews.id,
                                    );
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom action buttons
              Padding(
                padding: EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Delete button stack
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (context) => Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Silinen Kartlar',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    if (deletedNews.isEmpty)
                                      Expanded(
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.delete_outline,
                                                size: 64,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(height: 16),
                                              Text(
                                                'Henüz kart silinmedi',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    else
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: deletedNews.length,
                                          itemBuilder: (context, index) {
                                            final news = deletedNews[index];
                                            return Dismissible(
                                              key: Key(news.id.toString()),
                                              direction:
                                                  DismissDirection.endToStart,
                                              background: Container(
                                                color: Colors.red,
                                                alignment:
                                                    Alignment.centerRight,
                                                padding: EdgeInsets.only(
                                                  right: 20,
                                                ),
                                                child: Icon(
                                                  Icons.delete_forever,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              onDismissed: (direction) {
                                                setState(() {
                                                  deletedNews.removeAt(index);
                                                });
                                              },
                                              child: ListTile(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          NewsDetailScreen(
                                                        news: news,
                                                        getCategoryColor:
                                                            getCategoryColor,
                                                        getReadTimeText:
                                                            getReadTimeText,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                leading: Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors:
                                                          news.gradientColors,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      8,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      news.icon,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                title: Text(
                                                  news.title,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                subtitle: Text(
                                                  news.category,
                                                  style: TextStyle(
                                                    color: getCategoryColor(
                                                      news.category,
                                                    ),
                                                  ),
                                                ),
                                                trailing: Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 16,
                                                  color: Color(0xFF6B7280),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                              size: 32,
                            ),
                          ),
                        ),
                        if (deletedNews.isNotEmpty)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${deletedNews.length}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    // Bookmark button stack
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (context) => Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Kaydedilen Haberler',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    if (bookmarkedNews.isEmpty)
                                      Expanded(
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.bookmark_border,
                                                size: 64,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(height: 16),
                                              Text(
                                                'Henüz haber kaydedilmedi',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    else
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: bookmarkedNews.length,
                                          itemBuilder: (context, index) {
                                            final news = bookmarkedNews[index];
                                            return Dismissible(
                                              key: Key(news.id.toString()),
                                              direction:
                                                  DismissDirection.endToStart,
                                              background: Container(
                                                color: Colors.red,
                                                alignment:
                                                    Alignment.centerRight,
                                                padding: EdgeInsets.only(
                                                  right: 20,
                                                ),
                                                child: Icon(
                                                  Icons.bookmark_remove,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              onDismissed: (direction) {
                                                setState(() {
                                                  bookmarkedNews.removeAt(
                                                    index,
                                                  );
                                                  news.isBookmarked = false;
                                                });
                                              },
                                              child: ListTile(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          NewsDetailScreen(
                                                        news: news,
                                                        getCategoryColor:
                                                            getCategoryColor,
                                                        getReadTimeText:
                                                            getReadTimeText,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                leading: Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors:
                                                          news.gradientColors,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      8,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      news.icon,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                title: Text(
                                                  news.title,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                subtitle: Text(
                                                  news.category,
                                                  style: TextStyle(
                                                    color: getCategoryColor(
                                                      news.category,
                                                    ),
                                                  ),
                                                ),
                                                trailing: Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 16,
                                                  color: Color(0xFF6B7280),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.bookmark,
                              color: Color(0xFF7C3AED),
                              size: 32,
                            ),
                          ),
                        ),
                        if (bookmarkedNews.isNotEmpty)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Color(0xFF7C3AED),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${bookmarkedNews.length}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
