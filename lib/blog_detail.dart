import 'package:flutter/material.dart';
import 'package:blog/model/blog_model.dart';

class BlogDetailPage extends StatefulWidget {
  final BlogModel blog;

  const BlogDetailPage({super.key, required this.blog});

  @override
  // ignore: library_private_types_in_public_api
  _BlogDetailPageState createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends State<BlogDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.blog.title!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Image.network(widget.blog.imageurl!),
                IconButton(
                  onPressed: () {
                    setState(() {
                      widget.blog.isFavorite = !widget.blog.isFavorite;
                    });
                  },
                  icon: Icon(
                    widget.blog.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: widget.blog.isFavorite ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.blog.title!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
