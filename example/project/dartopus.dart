import 'my_first_routes.dart';
import 'package:dartopus/src/core/middleware.dart';
import 'package:dartopus/src/core/router.dart';
import 'package:dartopus/src/core/server.dart';
import 'package:dartopus/src/enums/http_methods.dart';
import 'package:dartopus/src/middleware/documentation_middleware.dart';

void main() {
  final DocumentationMiddleware docMiddleware = DocumentationMiddleware();
  Router router = Router(docMiddleware: docMiddleware);

  router
    ..add(HttpMethod.GET, '/', rootHandler)
    ..add(HttpMethod.POST, '/hello', helloHandler);

  final Server server = Server(router, middlewares: [Middleware(), docMiddleware]);

  server.listen(address: 'localhost', port: 8080);
}
