import 'package:flutter/material.dart';
import 'package:skeleton/skeleton.dart';

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
              width: 64,
              height: 64,
              borderRadius: BorderRadius.circular(32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonText(
                    'Sarah Anderson',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SkeletonText(
                    '@sarahdesigns',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
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
                'https://picsum.photos/400/200?random=2',
              ),
              width: double.infinity,
              height: 200,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 16),
            SkeletonText(
              'The Future of Flutter Design Patterns',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            SkeletonText(
              'Learn about the latest design patterns and best practices for building scalable Flutter applications.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),
            SkeletonBox(
              color: Colors.blue.shade50,
              width: 100,
              height: 32,
              child: Container(),
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
              width: 80,
              height: 80,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonText(
                    'Premium Wireless Headphones',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SkeletonText(
                    '⭐ 4.8 (2,341 reviews)',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.amber[700]),
                  ),
                  const SizedBox(height: 8),
                  SkeletonBox(
                    color: Colors.green[50]!,
                    width: 70,
                    height: 28,
                    child: Container(),
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
