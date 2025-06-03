import 'package:flutter/material.dart';

/// Haber öğesi modeli
///
/// Bu sınıf, uygulama içindeki her bir haber kartını temsil eder.
class NewsItem {
  /// Haberin benzersiz kimliği
  final int id;

  /// Haber başlığı
  final String title;

  /// Haber özeti
  final String summary;

  /// Haber kategorisi (Technology, Environment, vb.)
  final String category;

  /// Tahmini okuma süresi
  final String readTime;

  /// Haber kartının gradient renkleri
  final List<Color> gradientColors;

  /// Haber için emoji ikonu
  final String icon;

  /// Haber resmi için URL
  final String imageUrl;

  /// Haberin detaylı okunabilirlik bağlantısı
  final String? readMoreUrl;

  /// Haberin okuma sayısı
  int viewCount;

  /// Haberin son okunma zamanı
  DateTime? lastReadTime;

  /// Haberin yer imi durumu
  bool isBookmarked = false;

  NewsItem({
    required this.id,
    required this.title,
    required this.summary,
    required this.category,
    required this.readTime,
    required this.gradientColors,
    required this.icon,
    required this.imageUrl,
    this.readMoreUrl,
    this.viewCount = 0,
    this.lastReadTime,
  });

  /// Firestore veya JSON'dan veri çekerken kullanılacak factory metodu
  factory NewsItem.fromMap(Map<String, dynamic> data) {
    return NewsItem(
      id: data['id'],
      title: data['title'],
      summary: data['summary'],
      category: data['category'],
      readTime: data['readTime'],
      gradientColors: List<Color>.from(
          data['gradientColors'].map((color) => Color(int.parse(color)))),
      icon: data['icon'],
      imageUrl: data['imageUrl'] ?? '',
      readMoreUrl: data['readMoreUrl'],
      viewCount: data['viewCount'] ?? 0,
      lastReadTime: data['lastReadTime'] != null
          ? DateTime.parse(data['lastReadTime'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'category': category,
      'readTime': readTime,
      'gradientColors':
          gradientColors.map((color) => color.value.toString()).toList(),
      'icon': icon,
      'imageUrl': imageUrl,
      'readMoreUrl': readMoreUrl,
      'viewCount': viewCount,
      'lastReadTime': lastReadTime?.toIso8601String(),
    };
  }

  /// Trending durumunu kontrol eden static metod
  static List<NewsItem> getTrendingNews(List<NewsItem> allNews) {
    // Tüm haberleri viewCount'a göre sırala ve en fazla okunan 3'ünü al
    List<NewsItem> sortedNews = List.from(allNews);
    sortedNews.sort((a, b) => b.viewCount.compareTo(a.viewCount));
    return sortedNews.take(3).toList();
  }

  /// Bu haberin trending olup olmadığını kontrol eden getter
  bool isTrendingIn(List<NewsItem> allNews) {
    List<NewsItem> trendingNews = getTrendingNews(allNews);
    return trendingNews.contains(this);
  }
}
