import 'dart:io';
import 'dart:mirrors';

import 'package:dartopus/annotations/documentation_annotation.dart';
import 'package:dartopus/src/enums/http_methods.dart';
import 'package:dartopus/src/middleware/documentation_middleware.dart';

import 'handler.dart';
import 'request.dart';
import 'response.dart';

class Router {
  final DocumentationMiddleware? docMiddleware;

  Router({this.docMiddleware});
  final Map<String, Map<String, Handler>> _routes = {};

  Map<String, Map<String, Handler>> get routes => _routes;

  void add(HttpMethod method, String path, Handler handler) {
    final normalizedPath = _normalizePath(path);

    // Extract annotation data
    final routeInfo = _getRouteInfo(handler);
    print("gelen route info $routeInfo");

    // Register route with annotation data
    docMiddleware?.registerRoute(
      method,
      path,
      routeInfo?.headers,
      routeInfo?.responses,
    );

    _routes.putIfAbsent(method.name, () => {})[normalizedPath] = handler;
  }

  Future<void> handleRequest(Request req, Response res) async {
    final method = req.method;
    final path = _normalizePath(req.uri.path);

    final route = _routes[method]?[path];

    if (route != null) {
      await route(req, res);
    } else {
      res.setStatus(HttpStatus.notFound);
      res.write('404 Not Found');
      res.close();
    }
  }

  String _normalizePath(String path) {
    return path.endsWith('/') ? path.substring(0, path.length - 1) : path;
  }

  RouteInfo? _getRouteInfo(Handler handler) {
    // Yansıma kullanarak handler'ın türünü alıyoruz
    var handlerMirror = reflect(handler);

    // Handler'ın bir fonksiyon olduğunu kontrol ediyoruz
    if (handlerMirror.type.isSubtypeOf(reflectType(Function))) {
      // MethodMirror'ları alıyoruz
      var methodMirror = handlerMirror.type.declarations.values.firstWhere(
        (declaration) => declaration is MethodMirror,
        orElse: () => throw Exception('Handler için eşleşen bir yöntem bulunamadı'),
      ) as MethodMirror;

      // RouteInfo annotation'larını alıyoruz
      var routeInfo = methodMirror.metadata.where((m) => m.reflectee is RouteInfo).map((m) => m.reflectee as RouteInfo).firstOrNull;

      return routeInfo;
    }

    return null;
  }
}
