import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';

class NewsService {
  static const String _baseUrl = 'https://kite.kagi.com';

  Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/kite.json'));
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> categories = data['categories'];
        return categories.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getArticlesByCategory(String categoryFile) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$categoryFile'));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        // Extract articles from the clusters array
        final List<dynamic> clusters = data['clusters'] ?? [];
        final List<Map<String, dynamic>> allArticles = [];
        
        for (var cluster in clusters) {
          final List<dynamic> articles = cluster['articles'] ?? [];
          allArticles.addAll(articles.map((article) => article as Map<String, dynamic>));
        }
        
        return allArticles;
      } else {
        throw Exception('Failed to load articles');
      }
    } catch (e) {
      throw Exception('Failed to fetch articles: $e');
    }
  }
} 