import 'package:animation_playground/blocs/player/player_bloc.dart';
import 'package:animation_playground/blocs/room/room_bloc.dart';
import 'package:animation_playground/blocs/round/round_bloc.dart';
import 'package:animation_playground/data/source/remote/data_sources/player_remote_data_source.dart';
import 'package:animation_playground/data/source/remote/data_sources/room_remote_data_source.dart';
import 'package:animation_playground/data/source/remote/data_sources/round_remote_data_source.dart';
import 'package:animation_playground/main.dart';
import 'package:animation_playground/repositories/player_repository.dart';
import 'package:animation_playground/repositories/room_repository.dart';
import 'package:animation_playground/repositories/round_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../data/source/remote/services/dio_client.dart';

GetIt $initGetIt(GetIt getIt) {
  getIt.registerSingleton<DioService>(DioService(
    "http://$hostname:8090",
    Dio(),
  ));

  registerDataSource(getIt);
  registerRepository(getIt);
  registerBloC(getIt);

  return getIt;
}

void registerDataSource(GetIt getIt) {
  getIt.registerLazySingleton<RoomRemoteDataSource>(
    () => RoomRemoteDataSourceImpl(),
  );
  getIt.registerLazySingleton<PlayerRemoteDataSource>(
    () => PlayerRemoteDataSourceImpl(),
  );
  getIt.registerLazySingleton<RoundRemoteDataSource>(
    () => RoundRemoteDataSourceImpl(),
  );
}

void registerRepository(GetIt getIt) {
  getIt.registerLazySingleton<RoomRepository>(() => RoomRepositoryImpl());
  getIt.registerLazySingleton<PlayerRepository>(() => PlayerRepositoryImpl());
  getIt.registerLazySingleton<RoundRepository>(() => RoundRepositoryImpl());
}

void registerBloC(GetIt getIt) {
  getIt.registerFactory<RoomBloc>(() => RoomBloc());
  getIt.registerFactory<PlayerBloc>(() => PlayerBloc());
  getIt.registerFactory<RoundBloc>(() => RoundBloc());
}
