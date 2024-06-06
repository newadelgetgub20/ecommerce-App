import 'package:http/http.dart' as http;

Future<http.Response> customGet(
  Uri uri, {
  Map<String, String>? headers,
  Map<String, dynamic>? queryParameters,
}) async {
  try {
    final response = await http.get(
      uri.replace(queryParameters: queryParameters),
      headers: headers,
    );
    return response;
  } catch (e) {
    print('Error making GET request: $e');
    throw e;
  }
}
