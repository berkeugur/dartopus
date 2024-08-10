class RouteInfo {
  final String description;
  final Map<String, String> headers;
  final Map<String, String> responses;

  const RouteInfo({
    required this.description,
    required this.headers,
    required this.responses,
  });
}
