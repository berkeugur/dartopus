import 'package:dartopus/annotations/method_annotation.dart';
import 'package:dartopus/src/core/routes.dart';

import 'response_model.dart';
import 'package:dartopus/annotations/documentation_annotation.dart';
import 'package:dartopus/src/core/handler.dart';
import 'package:dartopus/src/core/request.dart';
import 'package:dartopus/src/core/response.dart';

class MyFirstRoutes extends Routes {
  @RouteInfo(
    description: 'Root endpoint',
    headers: {'Content-Type': 'text/plain'},
    responses: {"200": 'Hello, Dart server!'},
  )
  @GET("/")
  Handler get rootHandler => (Request req, Response res) async {
        res.json({"message": "hello"}, statusCode: 200);
      };

  @RouteInfo(
    description: 'Root endpoint',
    headers: {'Content-Type': 'text/plain'},
    responses: {"200": 'Hello, Dart server!'},
  )
  @GET("/berke")
  Handler get berkeHandler => (Request req, Response res) async {
        res.json({"name": "berke"}, statusCode: 200);
      };

  @RouteInfo(
    description: 'Hello endpoint',
    headers: {'Content-Type': 'application/json'},
    responses: {"204": '{"json": "deneme berke"}'},
  )
  @POST("/hello")
  Handler get helloHandler => (Request req, Response res) async {
        print(req.authorization);
        final body = await req.bodyAsModel<ResponseModel>(ResponseModel.fromJson);
        res.json(
          {"json": "deneme berke2", "body": body.toJson()},
          statusCode: 200,
        );
      };
}
