import 'my_first_routes.dart';
import 'package:dartopus/src/core/router.dart';
import 'package:dartopus/src/core/server.dart';
import 'package:dartopus/src/middleware/documentation_middleware.dart';

void main() {
  final DocumentationMiddleware docMiddleware = DocumentationMiddleware();

  final Server server = Server(
    Router(
      docMiddleware: docMiddleware,
      approutes: [
        MyFirstRoutes(),
      ],
    ),
    middlewares: [
      docMiddleware,
    ],
  );

  server.listen(address: 'localhost', port: 8080);
}
