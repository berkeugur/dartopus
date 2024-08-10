import 'dart:convert';
import 'dart:io';

class Response {
  final HttpResponse _httpResponse;

  Response(this._httpResponse);

  void setStatus(int statusCode) {
    _httpResponse.statusCode = statusCode;
  }

  void setHeaders(Map<String, String> headers) {
    headers.forEach((key, value) {
      _httpResponse.headers.set(key, value);
    });
  }

  void write(Object? message) {
    _httpResponse.write(message);
  }

  void close() {
    _httpResponse.close();
  }

  void json(Map<String, dynamic> json, {int statusCode = HttpStatus.ok}) {
    setStatus(statusCode);
    setHeaders({'Content-Type': 'application/json'});
    write(jsonEncode(json));
    close();
  }

  void html(String htmlContent, {int statusCode = HttpStatus.ok}) {
    setStatus(statusCode);
    setHeaders({'Content-Type': 'text/html'});
    write(htmlContent);
    close();
  }

  void text(String textContent, {int statusCode = HttpStatus.ok}) {
    setStatus(statusCode);
    setHeaders({'Content-Type': 'text/plain'});
    write(textContent);
    close();
  }

  void file(File file, {int statusCode = HttpStatus.ok}) async {
    setStatus(statusCode);
    setHeaders({'Content-Type': _getMimeType(file.path)});
    final fileStream = file.openRead();
    await fileStream.pipe(_httpResponse);
  }

  void redirect(String location, {int statusCode = HttpStatus.movedPermanently}) {
    setStatus(statusCode);
    setHeaders({'Location': location});
    close();
  }

  void sendFile(File file, {int statusCode = HttpStatus.ok}) async {
    setStatus(statusCode);
    final mimeType = _getMimeType(file.path);
    setHeaders({'Content-Type': mimeType});
    final fileStream = file.openRead();
    await fileStream.pipe(_httpResponse);
    close();
  }

  String _getMimeType(String path) {
    final extension = path.split('.').last.toLowerCase();
    switch (extension) {
      case 'html':
        return 'text/html';
      case 'json':
        return 'application/json';
      case 'css':
        return 'text/css';
      case 'js':
        return 'application/javascript';
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'gif':
        return 'image/gif';
      default:
        return 'application/octet-stream';
    }
  }
}
