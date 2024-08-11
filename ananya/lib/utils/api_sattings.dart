import 'package:ananya/utils/constants.dart';
import 'package:http/http.dart' as http;

class ApiSettings {
  String endPoint;
  late final String baseUrl = baseUri;
  late final String uri = baseUrl + endPoint;

  ApiSettings({required this.endPoint});

  Future<http.Response> postMethod(String data) async {
    try {
      final response = await http.post(
        Uri.parse(uri),
        headers: {
          'Content-Type': 'application/json',
        },
        body: data,
      );
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<http.Response> postMethodWithDiffEndPoint(
      String data, String ep) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + ep),
        headers: {
          'Content-Type': 'application/json',
        },
        body: data,
      );
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<http.Response> getMethod() async {
    try {
      final response = await http.get(
        Uri.parse(uri),
      );
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<http.Response> getMethodWithDiffEndPoint(String ep) async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl + ep),
      );
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<http.Response> putMethod(String data) async {
    try {
      final response = await http.put(
        Uri.parse(uri),
        headers: {
          'Content-Type': 'application/json',
        },
        body: data,
      );
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
