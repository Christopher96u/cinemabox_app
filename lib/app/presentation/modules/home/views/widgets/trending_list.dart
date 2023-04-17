import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/either/either.dart';
import '../../../../../domain/enums.dart';
import '../../../../../domain/failures/http_request/http_request_failure.dart';
import '../../../../../domain/models/media/media.dart';
import '../../../../../domain/repositories/trending_repository.dart';
import 'trending_tile.dart';
import 'trending_time_window.dart';

typedef EitherListMedia = Either<HttpRequestFailure, List<Media>>;

class TrendingList extends StatefulWidget {
  const TrendingList({Key? key}) : super(key: key);

  @override
  State<TrendingList> createState() => _TrendingListState();
}

class _TrendingListState extends State<TrendingList> {
  late Future<EitherListMedia> _future;
  TrendingRepository get _trendingRepository => context.read();
  TimeWindow _timeWindow = TimeWindow.day;

  @override
  void initState() {
    super.initState();
    _future = _trendingRepository.getMoviesAndSeries(_timeWindow);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TrendingTimeWindow(
          timeWindow: _timeWindow,
          onChanged: (timeWindow) {
            setState(() {
              _timeWindow = timeWindow;
              _future = _trendingRepository.getMoviesAndSeries(
                _timeWindow,
              );
            });
          },
        ),
        const SizedBox(
          height: 10,
        ),
        AspectRatio(
          aspectRatio: 16 / 8,
          child: LayoutBuilder(
            builder: (_, constraints) {
              final width = constraints.maxHeight * 0.65;
              return Center(
                child: FutureBuilder<EitherListMedia>(
                  key: ValueKey(_future),
                  future: _future,
                  builder: (_, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    return snapshot.data!.when(
                        left: (failure) => Text(
                              failure.toString(),
                            ),
                        right: (list) {
                          return ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            scrollDirection: Axis.horizontal,
                            itemCount: list.length,
                            itemBuilder: (_, index) {
                              final media = list[index];
                              return TrendingTile(
                                media: media,
                                width: width,
                              );
                            },
                            separatorBuilder: (_, __) => const SizedBox(
                              width: 10,
                            ),
                          );
                        });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}