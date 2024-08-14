// src/middleware/documentation_middleware.dart

import 'dart:convert';
import 'dart:io';
import 'package:dartopus/src/core/middleware.dart';
import 'package:dartopus/src/core/request.dart';
import 'package:dartopus/src/core/response.dart';
import 'package:dartopus/src/enums/http_methods.dart';

class DocumentationMiddleware extends Middleware {
  final List<Map<String, dynamic>> _routesInfos = [];

  void registerRoute(HttpMethod method, String path, [Map<String, String>? headers, Map<String, dynamic>? responses]) {
    print("gelen annotationlar");
    print(headers);
    print(responses);
    _routesInfos.add({'method': method.toString(), 'path': path, 'headers': headers ?? {}, 'responses': responses ?? {}});
  }

  @override
  Future<void> handle(Request req, Response res, Future<void> Function() next) async {
    if (req.uri.path == '/docs') {
      print("Dökümantasyonu ${req.uri.path} üzerinden kullanabilirsiniz.");
      final htmlContent = _generateHtmlDocumentation();
      res.setHeaders({'Content-Type': 'text/html'});
      res.write(htmlContent);

      res.close();
    } else {
      await next();
    }
  }

  String _generateHtmlDocumentation() {
    final templateFile = File('lib/src/middleware/documentation_template.html');
    final cssFile = File('lib/src/middleware/styles.css');
    final jsFile = File('lib/src/middleware/scripts.js');

    final template = templateFile.readAsStringSync();
    final css = cssFile.readAsStringSync();
    final js = jsFile.readAsStringSync();

    final routesJson = jsonEncode(_routesInfos).replaceAll("HttpMethod.", "");
    final htmlContent = template.replaceAll('{{routesData}}', routesJson).replaceAll('<link rel="stylesheet" type="text/css" href="styles.css">', '<style>$css</style>').replaceAll('<script src="scripts.js"></script>', '<script>$js</script>');

    return htmlContent;
  }
}
