import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:phuong_for_organizer/data/dataresources/post_feed_firebase_service_class.dart';

class FeedView extends StatelessWidget {
  final PostFeedFirebaseServiceClass _firebaseService = PostFeedFirebaseServiceClass();

  void _showDeleteConfirmation(BuildContext context, String postId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Delete this post?'),
        backgroundColor: Colors.red[800],
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'DELETE',
          textColor: Colors.white,
          onPressed: () async {
            await _firebaseService.deletePost(postId);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Post deleted successfully')),
            );
          },
        ),
      ),
    );
  }

  void _showImageViewer(BuildContext context, Map<String, dynamic> post) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder: (BuildContext context, _, __) {
          return ImageViewerPage(post: post);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _firebaseService.fetchPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.purple,
            ),
          );
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 48),
                SizedBox(height: 16),
                Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo_library_outlined, color: Colors.grey, size: 48),
                SizedBox(height: 16),
                Text(
                  'No posts yet\nStart sharing your moments!',
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final posts = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: MasonryGridView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: posts.length,
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              final post = posts[index];
              return Padding(
                padding: const EdgeInsets.all(3.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: GestureDetector(
                    onTap: () => _showImageViewer(context, post),
                    onLongPress: () => _showDeleteConfirmation(context, post['id']),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: 'post-${post['id']}',
                            child: Image.network(
                              post['imageUrl'],
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return AspectRatio(
                                  aspectRatio: 1,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                      color: Colors.purple,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    color: Colors.grey[850],
                                    child: Icon(Icons.error, color: Colors.red),
                                  ),
                                );
                              },
                            ),
                          ),
                          if (post['description'] != null && 
                              post['description'].toString().isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                post['description'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ),
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

// Create a separate page for image viewing
class ImageViewerPage extends StatelessWidget {
  final Map<String, dynamic> post;

  const ImageViewerPage({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Stack(
          children: [
            // Close button
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            // Image
            Center(
              child: Hero(
                tag: 'post-${post['id']}',
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.network(
                    post['imageUrl'],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            // Description
            if (post['description'] != null && 
                post['description'].toString().isNotEmpty)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black87,
                        Colors.transparent,
                      ],
                    ),
                  ),
                  padding: EdgeInsets.all(20),
                  child: Text(
                    post['description'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
