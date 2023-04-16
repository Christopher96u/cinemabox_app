import '../../../domain/models/user/user.dart';
import '../../http/http.dart';

class AccountAPI {
  AccountAPI(this._http);

  final Http _http;

  Future<User?> getAccount(String sessionId) async {
    final result = await _http.request(
      '/account',
      onSuccess: (json) {
        return User.fromJson(json);
      },
      queryParameters: {
        'session_id': sessionId,
      },
    );

    return result.when(
      left: (_) => null,
      right: (user) => user,
    );
  }
}
