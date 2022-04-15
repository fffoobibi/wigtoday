import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

typedef CallBack = Function(Map<String, dynamic> data);
typedef ErrBack = Function(DioError error);

class HttpUtil {
  static const _domain = 'http://192.168.0.178/v1';
  static final _dio = _createDio();

  static Dio _createDio() {
    final _dio = Dio();
    _dio.options.baseUrl = _domain;
    _dio.options.connectTimeout = 5000;
    _dio.options.receiveTimeout = 5000;
    _dio.options.responseType = ResponseType.json;
    _dio.interceptors.add(InterceptorsWrapper(onError: (DioError e, handle) {
      print('net error: $e');
      Fluttertoast.showToast(
          msg: 'net work error, $e', gravity: ToastGravity.TOP);
      // handle.resolve(Response(requestOptions: requestOptions));
      handle.next(e);
    }));
    return _dio;
  }

  static get domain => _domain;

  static Future<Map<String, dynamic>> get(String urlPath,
      {Map<String, dynamic>? headers, Options? options}) async {
    Options? opt;
    if (headers != null) {
      if (options != null) {
        opt = options;
        opt.headers!.addAll(headers);
      } else {
        opt = Options(headers: headers);
      }
    } else {
      opt = options;
    }

    final response = await _dio.get(
      urlPath,
      options: options,
    );
    print('get ===. ${response.data} ${urlPath}');
    return response.data;
  }

  static Future<Map<String, dynamic>> post(String urlPath,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? headers,
      FormData? fdata,
      Options? options}) async {
    Options? opt;
    if (headers != null) {
      if (options != null) {
        opt = options;
        opt.headers!.addAll(headers);
      } else {
        opt = Options(headers: headers);
      }
    } else {
      opt = options;
    }
    FormData? pdata;
    if (fdata != null) {
      pdata = fdata;
    } else {
      pdata = data != null ? FormData.fromMap(data) : null;
    }
    final response = await _dio.post(urlPath, data: pdata, options: opt);
    return response.data;
  }
}
