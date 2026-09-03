import 'package:flutter/material.dart';
import 'package:skeleton_tint/skeleton_tint.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Skeleton Loading Demo'),
            elevation: 0,
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Loading'),
                Tab(text: 'Loaded'),
              ],
            ),
          ),
          body: const TabBarView(children: [_LoadingTab(), _LoadedTab()]),
        ),
      ),
    );
  }
}

class _LoadingTab extends StatelessWidget {
  const _LoadingTab();

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      loading: true,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _UserCard(),
          const SizedBox(height: 16),
          _BlogPostCard(),
          const SizedBox(height: 16),
          _ProductCard(),
        ],
      ),
    );
  }
}

class _LoadedTab extends StatelessWidget {
  const _LoadedTab();

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      loading: false,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _UserCard(),
          const SizedBox(height: 16),
          _BlogPostCard(),
          const SizedBox(height: 16),
          _ProductCard(),
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SkeletonImage(
              image: const NetworkImage('https://picsum.photos/64/64?random=1'),
              borderRadius: BorderRadius.circular(32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonText(
                    child: Text(
                      'Sarah Anderson',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SkeletonText(
                    child: Text(
                      '@sarahdesigns',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlogPostCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonImage(
              image: const NetworkImage(
                'https://picsum.photos/280/140?random=2',
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 16),
            SkeletonText(
              child: Text(
                'The Future of Flutter Design Patterns',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SkeletonText(
              child: Text(
                'Learn about the latest design patterns and best practices '
                'for building scalable Flutter applications.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
              ),
            ),
            const SizedBox(height: 12),
            SkeletonBox(
              child: Container(
                width: 100,
                height: 32,
                alignment: Alignment.center,
                color: Colors.blue.shade50,
                child: const Text('\$149.99'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SkeletonImage(
              image: const NetworkImage('https://picsum.photos/80/80?random=3'),
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonText(
                    child: Text(
                      'Premium Wireless Headphones',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SkeletonText(
                    child: Text(
                      '⭐ 4.8 (2,341 reviews)',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.amber[700]),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SkeletonBox(
                    child: Container(
                      width: 70,
                      height: 28,
                      alignment: Alignment.center,
                      color: Colors.green[50],
                      child: const Text('In Stock'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
