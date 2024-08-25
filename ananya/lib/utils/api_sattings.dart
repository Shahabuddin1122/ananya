import 'package:ananya/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiSettings {
  String endPoint;
  late final String baseUrl = baseUri;
  late final String uri = baseUrl + endPoint;

  ApiSettings({required this.endPoint});

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('tokenn');
    return token;
  }

  Future<http.Response> postMethod(String data) async {
    try {
      String? token = await _getToken();
      print(token);
      final response = await http.post(
        Uri.parse(uri),
        headers: {
          'Content-Type': 'application/json',
          // if (token != null) 'Authorization': 'Bearer $token',
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
      String? token = await _getToken();
      final response = await http.post(
        Uri.parse(baseUrl + ep),
        headers: {
          'Content-Type': 'application/json',
          // if (token != null) 'Authorization': 'Bearer $token',
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
      String? token = await _getToken();
      final response = await http.get(
        Uri.parse(uri),
        headers: {
          // if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<http.Response> getMethodWithDiffEndPoint(String ep) async {
    try {
      String? token = await _getToken();
      final response = await http.get(
        Uri.parse(baseUrl + ep),
        headers: {
          // if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<http.Response> putMethod(String data) async {
    try {
      String? token = await _getToken();
      final response = await http.put(
        Uri.parse(uri),
        headers: {
          'Content-Type': 'application/json',
          // if (token != null) 'Authorization': 'Bearer $token',
        },
        body: data,
      );
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
