import 'dart:io';
import 'dart:convert';

/// A wrapper class for handling HTTP requests in a more convenient and structured manner.
class Request {
  final HttpRequest _httpRequest;

  Request(this._httpRequest);

  /// Returns the HTTP method (e.g., GET, POST, PUT) of the request.
  String get method => _httpRequest.method;

  /// Returns the URI of the request, including the path and query parameters.
  Uri get uri => _httpRequest.uri;
  String get path => _httpRequest.uri.path;
  String get query => _httpRequest.uri.query;
  String get fragment => _httpRequest.uri.fragment;
  String get scheme => _httpRequest.uri.scheme;
  String get authority => _httpRequest.uri.authority;

  /// Returns the headers associated with the request.
  HttpHeaders get headers => _httpRequest.headers;

  /// Retrieves common HTTP headers as properties.
  String? get authorization => headers.value(HttpHeaders.authorizationHeader);
  String? get contentType => headers.value(HttpHeaders.contentTypeHeader);
  String? get accept => headers.value(HttpHeaders.acceptHeader);
  String? get acceptEncoding => headers.value(HttpHeaders.acceptEncodingHeader);
  String? get acceptLanguage => headers.value(HttpHeaders.acceptLanguageHeader);
  String? get userAgent => headers.value(HttpHeaders.userAgentHeader);
  String? get referer => headers.value(HttpHeaders.refererHeader);
  String? get connection => headers.value(HttpHeaders.connectionHeader);
  String? get contentLength => headers.value(HttpHeaders.contentLengthHeader);
  String? get cookie => headers.value(HttpHeaders.cookieHeader);
  String? get cacheControl => headers.value(HttpHeaders.cacheControlHeader);
  String? get pragma => headers.value(HttpHeaders.pragmaHeader);

  /// Provides access to the HttpResponse object for sending responses.
  HttpResponse get response => _httpRequest.response;

  /// Returns the query parameters from the URI as a map of key-value pairs.
  Map<String, String> get queryParams => _httpRequest.uri.queryParameters;

  /// Reads the request body as a string, decoding based on content type.
  Future<String> bodyAsString() async {
    final mimeType = _httpRequest.headers.contentType?.mimeType;
    final bytes = await _httpRequest.fold<List<int>>(
      <int>[],
      (List<int> previous, List<int> element) => previous..addAll(element),
    );

    switch (mimeType) {
      case 'application/json':
      case 'application/x-www-form-urlencoded':
      case 'text/plain':
        return utf8.decode(bytes);
      default:
        throw UnsupportedError('Unsupported content type: $mimeType');
    }
  }

  /// Reads the request body as JSON and decodes it into a Dart Map.
  Future<Map<String, dynamic>> bodyAsJson() async {
    final bodyString = await bodyAsString();
    return jsonDecode(bodyString) as Map<String, dynamic>;
  }

  /// Reads the request body as form data and returns it as a Map of key-value pairs.
  Future<Map<String, String>> bodyAsFormData() async {
    final bodyString = await bodyAsString();
    return Uri.splitQueryString(bodyString);
  }

  /// Retrieves the value of a specific header, or null if the header is not present.
  String? getHeader(String name) {
    return _httpRequest.headers.value(name);
  }

  /// Checks if the request content type matches the specified MIME type.
  bool isContentType(String mimeType) {
    return _httpRequest.headers.contentType?.mimeType == mimeType;
  }

  /// Returns the client's IP address.
  String get clientIp {
    return _httpRequest.connectionInfo?.remoteAddress.address ?? 'Unknown';
  }

  /// Returns the host associated with the request.
  String get host => _httpRequest.headers.host ?? 'Unknown';

  /// Returns the port associated with the request.
  int get port => _httpRequest.connectionInfo?.remotePort ?? -1;

  /// Returns whether the request is secure (i.e., using HTTPS).
  bool get isSecure => _httpRequest.connectionInfo?.remoteAddress.isLoopback ?? false;

  /// Reads the request body as JSON and automatically converts it to a Dart model using a provided `fromJson` function.
  ///
  /// This method requires that the `fromJson` function be passed, typically as a model's `fromJson` constructor.
  Future<T> bodyAsModel<T>(T Function(Map<String, dynamic>) fromJsonT) async {
    final jsonMap = await bodyAsJson();
    return fromJsonT(jsonMap);
  }
}
