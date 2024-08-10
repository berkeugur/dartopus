import 'response_model.dart';
import 'package:dartopus/annotations/documentation_annotation.dart';
import 'package:dartopus/src/core/handler.dart';
import 'package:dartopus/src/core/request.dart';
import 'package:dartopus/src/core/response.dart';

@RouteInfo(
  description: 'Root endpoint',
  headers: {'Content-Type': 'text/plain'},
  responses: {"200": 'Hello, Dart server!'},
)
Handler get rootHandler => (Request req, Response res) async {
      res.json({"message": "hello"}, statusCode: 200);
    };

@RouteInfo(
  description: 'Hello endpoint',
  headers: {'Content-Type': 'application/json'},
  responses: {"204": '{"json": "deneme berke"}'},
)
Handler get helloHandler => (Request req, Response res) async {
      print(req.authorization);
      final body = await req.bodyAsModel<ResponseModel>(ResponseModel.fromJson);
      res.json(
        {"json": "deneme berke2", "body": body.toJson()},
        statusCode: 200,
      );
    };
