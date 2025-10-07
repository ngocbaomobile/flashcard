import 'package:get_it/get_it.dart';
import '../../data/datasources/local/flash_card_local_datasource.dart';
import '../../data/datasources/local/flash_card_local_datasource_impl.dart';
import '../../data/repositories/flash_card_repository_impl.dart';
import '../../data/repositories/random_text_repository_impl.dart';
import '../../domain/repositories/flash_card_repository.dart';
import '../../domain/repositories/random_text_repository.dart';
import '../../domain/usecases/get_all_flash_cards.dart';
import '../../domain/usecases/create_flash_card.dart';
import '../../domain/usecases/delete_flash_card.dart';
import '../../domain/usecases/parse_text_to_items.dart';
import '../../domain/usecases/select_random_item.dart';
import '../../presentation/bloc/flash_card_bloc.dart';
import '../../presentation/bloc/random_text_bloc.dart';

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

  sl.registerFactory(
    () => RandomTextBloc(
      parseTextToItemsUsecase: sl(),
      selectRandomItemUsecase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllFlashCardsUsecase(sl()));
  sl.registerLazySingleton(() => CreateFlashCardUsecase(sl()));
  sl.registerLazySingleton(() => DeleteFlashCardUsecase(sl()));
  sl.registerLazySingleton(() => ParseTextToItemsUsecase(sl()));
  sl.registerLazySingleton(() => SelectRandomItemUsecase(sl()));

  // Repository
  sl.registerLazySingleton<FlashCardRepository>(
    () => FlashCardRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton<RandomTextRepository>(
    () => RandomTextRepositoryImpl(),
  );

  // Data sources
  sl.registerLazySingleton<FlashCardLocalDataSource>(
    () => FlashCardLocalDataSourceImpl(),
  );
}
