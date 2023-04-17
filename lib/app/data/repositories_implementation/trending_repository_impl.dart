import '../../domain/models/media/media.dart';
import '../../domain/failures/http_request/http_request_failure.dart';
import '../../domain/enums.dart';
import '../../domain/either/either.dart';
import '../../domain/repositories/trending_repository.dart';
import '../services/remote/trending_api.dart';

class TrendingRepositoryImpl implements TrendingRepository {
  TrendingRepositoryImpl(this._trendingAPI);

  final TrendingAPI _trendingAPI;

  @override
  Future<Either<HttpRequestFailure, List<Media>>> getMoviesAndSeries(TimeWindow timeWindow) {
    return _trendingAPI.getMoviesAndSeries(
      timeWindow,
    );
  }
}