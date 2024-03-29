import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'app/data/http/http.dart';
import 'app/data/repositories_implementation/account_repository_impl.dart';
import 'app/data/repositories_implementation/authentication_repository_impl.dart';
import 'app/data/repositories_implementation/connectivity_repository_impl.dart';
import 'app/data/repositories_implementation/movies_repository_impl.dart';
import 'app/data/repositories_implementation/trending_repository_impl.dart';
import 'app/data/services/local/session_service.dart';
import 'app/data/services/remote/account_api.dart';
import 'app/data/services/remote/authentication_api.dart';
import 'app/data/services/remote/internet_checker.dart';
import 'app/data/services/remote/movies_api.dart';
import 'app/data/services/remote/trending_api.dart';
import 'app/domain/repositories/account_repository.dart';
import 'app/domain/repositories/authentication_repository.dart';
import 'app/domain/repositories/connectivity_repository.dart';
import 'app/domain/repositories/movies_repository.dart';
import 'app/domain/repositories/trending_repository.dart';
import 'app/my_app.dart';
import 'app/presentation/global/controllers/favorites/favorites_controller.dart';
import 'app/presentation/global/controllers/favorites/state/favorites_state.dart';
import 'app/presentation/global/controllers/session_controller.dart';

void main() {
  final http = Http(
    apiKey: '5ac04d36b118337ecbf822a1b8918f53',
    baseUrl: 'https://api.themoviedb.org/3',
    client: Client(),
  );
  final sessionService = SessionService(
    const FlutterSecureStorage(),
  );
  final accountAPI = AccountAPI(http, sessionService);
  runApp(
    MultiProvider(
      providers: [
        Provider<AccountRepository>(
          create: (_) {
            return AccountRepositoryImpl(
              accountAPI,
              sessionService,
            );
          },
        ),
        Provider<ConnectivityRepository>(
          create: (_) {
            return ConnectivityRepositoryImpl(
              Connectivity(),
              InternetChecker(),
            );
          },
        ),
        Provider<AuthenticationRepository>(
          create: (_) {
            return AuthenticationRepositoryImpl(
              AuthenticationAPI(
                http,
              ),
              accountAPI,
              sessionService,
            );
          },
        ),
        Provider<TrendingRepository>(
          create: (_) => TrendingRepositoryImpl(TrendingAPI(http)),
        ),
        Provider<MoviesRepository>(
          create: (_) => MoviesRepositoryImpl(MoviesAPI(http)),
        ),
        ChangeNotifierProvider<SessionController>(
          create: (context) => SessionController(
            authenticationRepository: context.read(),
          ),
        ),
        ChangeNotifierProvider<FavoritesController>(
          create: (context) => FavoritesController(
            FavoritesState.loading(),
            accountRepository: context.read(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
