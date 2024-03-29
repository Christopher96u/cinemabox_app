import 'package:flutter/material.dart';

class FavoritesAppBar extends StatelessWidget with PreferredSizeWidget {
  const FavoritesAppBar({Key? key, required this.tabController}) : super(key: key);
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleTextStyle: const TextStyle(
        color: Colors.black,
      ),
      elevation: 0,
      title: const Text(
        'Favourites',
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      bottom: TabBar(
        padding: const EdgeInsets.symmetric(vertical: 10),
        controller: tabController,
        indicator: const _Decoration(
          color: Colors.blueAccent,
          width: 20,
        ),
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Colors.black,
        tabs: const [
          Tab(
            text: 'Movies',
          ),
          Tab(
            text: 'Series',
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 2);
}

class _Decoration extends Decoration {
  const _Decoration({
    required this.color,
    required this.width,
  });

  final Color color;
  final double width;
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _Painter(color, width);
}

class _Painter extends BoxPainter {
  _Painter(
    this.color,
    this.width,
  );

  final Color color;
  final double width;
  @override
  void paint(
    Canvas canvas,
    Offset offset,
    ImageConfiguration configuration,
  ) {
    final size = configuration.size ?? Size.zero;
    final paint = Paint()..color = Colors.black45;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            size.width * 0.5 + offset.dx - width * 0.5,
            size.height * 0.9,
            width,
            width * 0.3,
          ),
          const Radius.circular(4),
        ),
        paint);
  }
}
