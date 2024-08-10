import 'dart:async';
import 'dart:io';

import 'package:dartopus/src/core/handler.dart';

import 'router.dart';
import 'middleware.dart';
import 'request.dart';
import 'response.dart';

class Server {
  final Router _router;
  final List<Middleware> _middlewares;

  Server(this._router, {List<Middleware>? middlewares}) : _middlewares = middlewares ?? [];

  Future<void> listen({String address = 'localhost', int port = 8080}) async {
    final server = await HttpServer.bind(address, port);
    print('Server running at http://$address:$port/');

    await for (HttpRequest request in server) {
      final requestWrapper = Request(request);
      final responseWrapper = Response(request.response);

      _handleRequest(requestWrapper, responseWrapper);
    }
  }

  Future<void> _handleRequest(Request req, Response res) async {
    try {
      await _executeMiddlewares(req, res, _router.handleRequest);
    } catch (e) {
      _handleError(e, res);
    }
  }

  Future<void> _executeMiddlewares(Request req, Response res, Handler handler) async {
    var index = 0;

    Future<void> next() async {
      if (index < _middlewares.length) {
        final middleware = _middlewares[index];
        index++;
        await middleware.handle(req, res, next);
      } else {
        await handler(req, res);
      }
    }

    await next();
  }

  void _handleError(Object error, Response res) {
    print('Error: $error');
    res.setStatus(HttpStatus.internalServerError);
    res.write('Internal Server Error');
    res.close();
  }
}
