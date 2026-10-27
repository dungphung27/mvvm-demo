import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class PostService {
  Future<List<Post>> fetchPosts(bool simulateError) async {
    await Future.delayed(const Duration(seconds: 1));

    String url = 'https://jsonplaceholder.typicode.com/posts?_limit=15';
    if (simulateError) {
      url = 'https://jsonplaceholder.typicode.com/khong-ton-tai';
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Mã lỗi ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as List;
    List<Post> posts = [];
    for (var item in data) {
      posts.add(Post.fromJson(item));
    }
    return posts;
  }
}
