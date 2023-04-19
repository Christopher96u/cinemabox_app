import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/home_controller.dart';
import '../controller/state/home_state.dart';
import 'widgets/movies_and_series/trending_list.dart';
import 'widgets/performers/trending_performers.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeController(
        HomeState(),
        trendingRepository: context.read(),
      )..init(),
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<HomeController>().init();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: constraints.maxHeight,
                    child: Column(
                      children: const [
                        SizedBox(
                          height: 10,
                        ),
                        TrendingList(),
                        SizedBox(
                          height: 20,
                        ),
                        TrendingPerformers(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
