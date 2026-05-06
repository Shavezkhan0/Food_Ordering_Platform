import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager extends CacheManager {
  static const key = 'customCacheKey';

  static final instance = CustomCacheManager._();

  CustomCacheManager._()
      : super(
          Config(
            key,
            stalePeriod: const Duration(seconds: 20),
            maxNrOfCacheObjects:
                200, // Maximum number of items to store in cache
            repo: JsonCacheInfoRepository(
                databaseName: key), // SQLite for cache info
            fileService: HttpFileService(),
          ),
        );
}
