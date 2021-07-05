import 'package:dio/dio.dart';
import 'package:garage/networking/request_logger.dart';
import 'package:garage/tool/tools.dart';

enum HTTPMethod { GET, POST }

typedef SucceedCallback = void Function(Map<String, dynamic> responseData);
typedef FailureCallback = void Function(String errorMsg);

class Networking {
  static final _dio = Dio(
    BaseOptions(
      baseUrl: 'http://120.48.27.13:9527',
      connectTimeout: 15000,
      headers: {'header': '18796945365'},
    ),
  );

  static Future<Map<String, dynamic>?> request(
    String path, {
    HTTPMethod method = HTTPMethod.POST,
    Map<String, dynamic>? queryParameters,
    Interceptor? inter,
    SucceedCallback? succeedCallback,
    FailureCallback? failureCallback,
  }) async {
    // 1.请求的单独配置
    final options = Options(
        method: method == HTTPMethod.GET ? 'get' : 'post',
        contentType: method == HTTPMethod.GET
            ? 'application/x-www-form-urlencoded'
            : 'application/json');

    // 2.拦截器
    // Interceptor dInter = InterceptorsWrapper(
    //     onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
    //   // 1.在进行任何网络请求的时候, 可以添加一个loading显示
    //   // 2.很多页面的访问必须要求携带Token,那么就可以在这里判断是有Token
    //   // 3.对参数进行一些处理,比如序列化处理等
    //   print("拦截了请求");
    //   return options;
    // }, onResponse: (Response response, ResponseInterceptorHandler handler) {
    //   print("拦截了响应");
    //   return response;
    // }, onError: (DioError error, ErrorInterceptorHandler handler) {
    //   print("拦截了错误");
    //   return error;
    // });
    // List<Interceptor> inters = [dInter];
    // if (inter != null) {
    //   inters.add(inter);
    // }
    // _dio.interceptors.addAll(inters);

    RequestLogger.printRequest(path, queryParameters!);

    // 3.发送网络请求
    try {
      final response;
      // get queryParameters, post data
      if (method == HTTPMethod.GET) {
        response = await _dio.request<Map<String, dynamic>>(path,
            queryParameters: queryParameters, options: options);
      } else {
        response = await _dio.request<Map<String, dynamic>>(path,
            data: queryParameters, options: options);
      }
      final responseData = response.data;

      if (responseData == null) {
        if (failureCallback != null) {
          toast('unknown error');
          failureCallback('unknown error');
        }
        return null;
      }

      RequestLogger.printResponse(path, responseData);

      if (responseData['code'] != 200) {
        if (failureCallback != null) {
          toast(responseData['msg']);
          failureCallback(responseData['msg']);
        }
        return null;
      }
      if (succeedCallback != null) {
        succeedCallback(responseData['data']);
      }
      return responseData['data'];
    } on DioError catch (e) {
      if (failureCallback != null) {
        failureCallback(e.toString());
      }
      return Future.error(e);
    }
  }
}
