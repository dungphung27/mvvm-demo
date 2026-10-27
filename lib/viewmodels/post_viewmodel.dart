import 'package:flutter/foundation.dart';
import '../models/post.dart';
import '../services/post_service.dart';

class PostViewModel extends ChangeNotifier {
  final PostService service = PostService();

  List<Post> posts = [];
  bool isLoading = false;
  String? error;
  bool simulateError = false;

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      posts = await service.fetchPosts(simulateError);
    } catch (e) {
      posts = [];
      error = 'Không tải được dữ liệu';
    }

    isLoading = false;
    notifyListeners();
  }

  void setSimulateError(bool value) {
    simulateError = value;
    notifyListeners();
  }
}
