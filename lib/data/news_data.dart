import 'package:flutter/material.dart';
import '../models/news_item.dart';

final List<NewsItem> newsData = [
  NewsItem(
    id: 1,
    title: "Revolutionary AI Technology Transforms Healthcare Industry",
    summary:
        "New breakthrough in artificial intelligence is helping doctors diagnose diseases faster and more accurately than ever before.",
    category: "Technology",
    readTime: "3 min read",
    gradientColors: [Color(0xFF60A5FA), Color(0xFFA855F7), Color(0xFFEC4899)],
    icon: "🤖",
    imageUrl:
        "https://images.unsplash.com/photo-1558346490-a72e53ae2d4f?auto=format&fit=crop&q=80&w=500&h=250",
    viewCount: 0,
  ),
  NewsItem(
    id: 2,
    title: "Climate Summit Reaches Historic Agreement",
    summary:
        "World leaders unite on ambitious new climate targets, promising carbon neutrality by 2040.",
    category: "Environment",
    readTime: "5 min read",
    gradientColors: [Color(0xFF34D399), Color(0xFF14B8A6), Color(0xFF3B82F6)],
    icon: "🌍",
    imageUrl:
        "https://pbs.twimg.com/media/Gr4-g9fXcAA70Fl?format=jpg&name=900x900",
    viewCount: 0,
  ),
  NewsItem(
    id: 3,
    title: "Space Exploration Enters New Era",
    summary:
        "Private companies launch successful missions to Mars, opening new possibilities for human colonization.",
    category: "Science",
    readTime: "4 min read",
    gradientColors: [Color(0xFFA78BFA), Color(0xFF6366F1), Color(0xFF2563EB)],
    icon: "🚀",
    imageUrl:
        "https://images.unsplash.com/photo-1614728894747-a83421789f10?auto=format&fit=crop&q=80",
    viewCount: 0,
  ),
  NewsItem(
    id: 4,
    title: "Global Economy Shows Strong Recovery Signs",
    summary:
        "Markets surge as economic indicators point to sustained growth across major economies worldwide.",
    category: "Business",
    readTime: "2 min read",
    gradientColors: [Color(0xFFFBBF24), Color(0xFFF97316), Color(0xFFEF4444)],
    icon: "📈",
    imageUrl:
        "https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?auto=format&fit=crop&q=80",
    viewCount: 15,
  ),
  NewsItem(
    id: 5,
    title: "Breakthrough in Renewable Energy Storage",
    summary:
        "Scientists develop new battery technology that could revolutionize how we store and use clean energy.",
    category: "Technology",
    readTime: "6 min read",
    gradientColors: [Color(0xFF10B981), Color(0xFF06B6D4), Color(0xFF3B82F6)],
    icon: "⚡",
    imageUrl:
        "https://images.unsplash.com/photo-1509391366360-2e959784a276?auto=format&fit=crop&q=80",
    viewCount: 0,
  ),
  NewsItem(
    id: 6,
    title: "Ocean Cleanup Technology Shows Promise",
    summary:
        "New innovative methods are being deployed to remove plastic waste from ocean waters worldwide.",
    category: "Environment",
    readTime: "4 min read",
    gradientColors: [Color(0xFF06B6D4), Color(0xFF0891B2), Color(0xFF0F766E)],
    icon: "🌊",
    imageUrl:
        "https://images.unsplash.com/photo-1544551763-46a013bb70d5?auto=format&fit=crop&q=80",
    viewCount: 12,
  ),
  NewsItem(
    id: 7,
    title: "Quantum Computing Reaches New Milestone",
    summary:
        "Research teams achieve quantum supremacy in solving complex mathematical problems.",
    category: "Science",
    readTime: "5 min read",
    gradientColors: [Color(0xFF8B5CF6), Color(0xFF7C3AED), Color(0xFF6D28D9)],
    icon: "⚛️",
    imageUrl:
        "https://images.unsplash.com/photo-1635070041078-e363dbe005cb?auto=format&fit=crop&q=80",
    viewCount: 0,
  ),
  NewsItem(
    id: 8,
    title: "Mental Health Apps Show Significant Impact",
    summary:
        "Digital therapy platforms prove effective in treating anxiety and depression among users.",
    category: "Technology",
    readTime: "3 min read",
    gradientColors: [Color(0xFFEC4899), Color(0xFFF472B6), Color(0xFFFBBF24)],
    icon: "🧠",
    imageUrl:
        "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?auto=format&fit=crop&q=80",
    viewCount: 8,
  ),
];
