import 'request.dart';
import 'response.dart';

typedef Handler = Future<void> Function(Request req, Response res);
