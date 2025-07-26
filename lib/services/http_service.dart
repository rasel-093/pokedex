import 'package:dio/dio.dart';

class HttpService {
  HttpService();
  final _dio = Dio();

  Future<Response?> get(String path) async {
    try {
      Response response = await _dio.get(path);
      if (response.statusCode == 200) {
        return response;
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
