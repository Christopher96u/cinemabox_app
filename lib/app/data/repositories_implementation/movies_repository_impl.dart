import '../../domain/models/movie/movie.dart';
import '../../domain/failures/http_request/http_request_failure.dart';
import '../../domain/either/either.dart';
import '../../domain/repositories/movies_repository.dart';
import '../services/remote/movies_api.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  MoviesRepositoryImpl(this._moviesAPI);

  final MoviesAPI _moviesAPI;
  @override
  Future<Either<HttpRequestFailure, Movie>> getMovieById(int id) {
    return _moviesAPI.getMovieById(id);
  }
}
