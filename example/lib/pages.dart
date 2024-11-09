import 'package:flutter/cupertino.dart';

class FirstDemoPage extends StatelessWidget {
  const FirstDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final typography = CupertinoTheme.of(context).textTheme;
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList.list(
            children: [
              const SizedBox(height: 72),
              Text(
                'Home',
                style: typography.navLargeTitleTextStyle,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Top Pics',
                  style: typography.navTitleTextStyle,
                ),
              ),
              const _ContentRow(height: 300, width: 250),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Other items',
                  style: typography.navTitleTextStyle,
                ),
              ),
              const _ContentRow(
                height: 150,
                width: 150,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class SecondDemoPage extends StatelessWidget {
  const SecondDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final typography = CupertinoTheme.of(context).textTheme;
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList.list(
            children: [
              const SizedBox(height: 72),
              Text(
                'Items',
                style: typography.navLargeTitleTextStyle,
              ),
              const SizedBox(height: 16),
              const _ContentRow(
                height: 200,
                width: 200,
              ),
              const SizedBox(height: 16),
              const _ContentRow(
                height: 200,
                width: 200,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _ContentRow extends StatelessWidget {
  const _ContentRow({
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final colors = [
      CupertinoColors.systemBlue,
      CupertinoColors.systemCyan,
      CupertinoColors.systemGreen,
      CupertinoColors.systemIndigo,
      CupertinoColors.systemOrange,
      CupertinoColors.systemPink,
      CupertinoColors.systemPurple,
      CupertinoColors.systemRed,
      CupertinoColors.systemTeal
    ];

    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final randomColor = colors[index % colors.length];
          return Container(
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              color: randomColor,
            ),
            margin: const EdgeInsets.only(right: 16),
          );
        },
      ),
    );
  }
}
