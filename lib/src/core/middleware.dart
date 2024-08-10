import 'request.dart';
import 'response.dart';

class Middleware {
  Future<void> handle(Request req, Response res, Future<void> Function() next) async {
    // Middleware iş mantığı buraya eklenebilir
    await next();
  }
}
