import 'package:flutter/material.dart';
import '../viewmodels/post_viewmodel.dart';

class PostView extends StatefulWidget {
  const PostView({super.key});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final PostViewModel viewModel = PostViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.load();
  }

  String statusText() {
    if (viewModel.isLoading) {
      return 'Trạng thái: Đang tải (Loading)';
    }
    if (viewModel.error != null) {
      return 'Trạng thái: Báo lỗi (Error)';
    }
    return 'Trạng thái: Thành công (Success)';
  }

  Color statusColor() {
    if (viewModel.isLoading) {
      return Colors.orange;
    }
    if (viewModel.error != null) {
      return Colors.red;
    }
    return Colors.green;
  }

  Widget buildContent() {
    if (viewModel.isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Đang tải dữ liệu...'),
          ],
        ),
      );
    }

    if (viewModel.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text(viewModel.error!),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: viewModel.load,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: viewModel.posts.length,
      itemBuilder: (context, index) {
        final post = viewModel.posts[index];
        return ListTile(
          leading: CircleAvatar(child: Text('${post.id}')),
          title: Text(post.title),
          subtitle: Text(
            post.body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demo MVVM: danh sách bài viết')),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: statusColor(),
                child: Text(
                  statusText(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SwitchListTile(
                title: const Text('Giả lập lỗi mạng'),
                value: viewModel.simulateError,
                onChanged: viewModel.setSimulateError,
              ),
              ElevatedButton(
                onPressed: viewModel.load,
                child: const Text('Tải lại'),
              ),
              const Divider(),
              Expanded(child: buildContent()),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'View này không gọi mạng và không giải mã JSON. Nó chỉ đọc trạng thái từ ViewModel.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
