import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../global/controllers/favorites/favorites_controller.dart';
import '../../../global/widgets/request_failed.dart';
import 'widgets/favorites_app_bar.dart';
import 'widgets/favorites_content.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({Key? key}) : super(key: key);

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FavoritesController favoritesController = context.read();
    return Scaffold(
      appBar: FavoritesAppBar(
        tabController: _tabController,
      ),
      body: favoritesController.state.map(
        loading: (_) => const Center(
          child: CircularProgressIndicator(),
        ),
        failed: (_) => RequestFailed(
          onRetry: () => favoritesController.init(),
        ),
        loaded: (state) => FavoritesContent(
          state: state,
          tabController: _tabController,
        ),
      ),
    );
  }
}
