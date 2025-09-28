import 'package:get_it/get_it.dart';
import '../../data/datasources/local/flash_card_local_datasource.dart';
import '../../data/datasources/local/flash_card_local_datasource_impl.dart';
import '../../data/repositories/flash_card_repository_impl.dart';
import '../../domain/repositories/flash_card_repository.dart';
import '../../domain/usecases/get_all_flash_cards.dart';
import '../../domain/usecases/create_flash_card.dart';
import '../../domain/usecases/delete_flash_card.dart';
import '../../presentation/bloc/flash_card_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
    () => FlashCardBloc(
      getAllFlashCards: sl(),
      createFlashCard: sl(),
      deleteFlashCard: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllFlashCardsUsecase(sl()));
  sl.registerLazySingleton(() => CreateFlashCardUsecase(sl()));
  sl.registerLazySingleton(() => DeleteFlashCardUsecase(sl()));

  // Repository
  sl.registerLazySingleton<FlashCardRepository>(
    () => FlashCardRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<FlashCardLocalDataSource>(
    () => FlashCardLocalDataSourceImpl(),
  );
}
