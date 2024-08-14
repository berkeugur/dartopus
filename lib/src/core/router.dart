import 'dart:io';
import 'dart:mirrors';

import 'package:dartopus/annotations/documentation_annotation.dart';
import 'package:dartopus/annotations/method_annotation.dart';
import 'package:dartopus/src/core/routes.dart';
import 'package:dartopus/src/enums/http_methods.dart';
import 'package:dartopus/src/middleware/documentation_middleware.dart';

import 'handler.dart';
import 'request.dart';
import 'response.dart';

class Router {
  final DocumentationMiddleware? docMiddleware;
  final List<Routes> approutes;
  Router({this.docMiddleware, required this.approutes}) {
    _populateRoutes();
  }
  Map<String, Map<String, Handler>> routes = {};

  void _populateRoutes() {
    for (var routeClass in approutes) {
      var classMirror = reflect(routeClass);

      for (var declaration in classMirror.type.declarations.values) {
        if (declaration is MethodMirror && !declaration.isConstructor) {
          var httpMethod = _getHttpMethod(declaration.metadata);
          var path = _getPath(declaration.metadata);

          if (httpMethod != null && path != null) {
            var handler = classMirror.getField(declaration.simpleName).reflectee as Handler;
            add(httpMethod, path, handler);
          }
        }
      }
    }
  }

  HttpMethod? _getHttpMethod(List<InstanceMirror> metadata) {
    for (var meta in metadata) {
      var reflectee = meta.reflectee;
      if (reflectee is GET) return HttpMethod.GET;
      if (reflectee is POST) return HttpMethod.POST;
      if (reflectee is PUT) return HttpMethod.PUT;
      if (reflectee is DELETE) return HttpMethod.DELETE;
    }
    return null;
  }

  String? _getPath(List<InstanceMirror> metadata) {
    for (var meta in metadata) {
      var reflectee = meta.reflectee;
      if (reflectee is GET) return reflectee.path;
      if (reflectee is POST) return reflectee.path;
      if (reflectee is PUT) return reflectee.path;
      if (reflectee is DELETE) return reflectee.path;
    }
    return null;
  }

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

    routes.putIfAbsent(method.name, () => {})[normalizedPath] = handler;
  }

  Future<void> handleRequest(Request req, Response res) async {
    final method = req.method;
    final path = _normalizePath(req.uri.path);

    final route = routes[method]?[path];

    if (route != null) {
      await route(req, res);
    } else {
      res.setStatus(HttpStatus.notFound);
      res.write('Not Found');
      res.close();
    }
  }

  String _normalizePath(String path) {
    return path.endsWith('/') ? path.substring(0, path.length - 1) : path;
  }

  RouteInfo? _getRouteInfo(Handler handler) {
    // Get the Type of the handler
    var handlerType = handler.runtimeType;

    // Reflect on the class of the handler
    var classMirror = reflectClass(handlerType);

    // Iterate over the class's declarations
    for (var declaration in classMirror.declarations.values) {
      if (declaration is MethodMirror) {
        // Check if the method has the RouteInfo annotation
        for (var meta in declaration.metadata) {
          if (meta.reflectee is RouteInfo) {
            return meta.reflectee as RouteInfo;
          }
        }
      }
    }

    return null;
  }
}
