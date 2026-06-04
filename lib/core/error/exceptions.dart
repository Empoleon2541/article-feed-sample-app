class ServerException implements Exception {
  final String message;
  const ServerException({this.message = 'Server error'});

  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  final String message;
  const CacheException({this.message = 'Cache error'});

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {
  final String message;
  const NetworkException({this.message = 'No internet connection'});

  @override
  String toString() => 'NetworkException: $message';
}
