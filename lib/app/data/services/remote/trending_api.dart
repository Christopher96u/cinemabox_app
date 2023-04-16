import '../../../domain/enums.dart';
import '../../../domain/models/media/media.dart';
import '../../../domain/typedefs.dart';
import '../../http/http.dart';

class TrendingAPI {
  TrendingAPI(this._http);
  final Http _http;

  getMoviesAndSeries(TimeWindow timeWindow) async {
    final result = await _http.request(
      '/trending/all/${timeWindow.name}',
      onSuccess: (json) {
        final list = json['result'] as List<Json>;
        return list
            .where(
              (element) => element['media_type'] != 'person',
            )
            .map(
              (element) => Media.fromJson(element),
            )
            .toList();
      },
    );
  }
}
