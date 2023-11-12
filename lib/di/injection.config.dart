import 'package:animation_playground/blocs/room/room_bloc.dart';
import 'package:animation_playground/data/source/remote/data_sources/room_remote_data_source.dart';
import 'package:animation_playground/repositories/room_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../core/config/build_config.dart';
import '../data/source/remote/services/dio_client.dart';

GetIt $initGetIt(GetIt getIt) {
  getIt.registerSingleton<DioService>(DioService(
    BuildConfig.instance.environment.url,
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
}

void registerRepository(GetIt getIt) {
  getIt.registerLazySingleton<RoomRepository>(() => RoomRepositoryImpl());
}

void registerBloC(GetIt getIt) {
  getIt.registerFactory<RoomBloc>(() => RoomBloc());
}
