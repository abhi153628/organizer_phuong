import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:phuong_for_organizer/data/dataresources/post_feed_firebase_service_class.dart';

class FeedView extends StatelessWidget {
  final PostFeedFirebaseServiceClass _firebaseService = PostFeedFirebaseServiceClass();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _firebaseService.fetchPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No posts available'));
        }

        final posts = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: MasonryGridView.builder(
             physics: NeverScrollableScrollPhysics(),
            itemCount: posts.length,
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) {
              final post = posts[index];
              return Padding(
                padding: const EdgeInsets.all(3.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Column(
                    children: [
                      Image.network(
                        post['imageUrl'],
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          post['description'] ?? '',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
