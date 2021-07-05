import 'dart:convert';

class RequestLogger {
  static void printRequest(String url, Map parameters) {
    print('''
  
------------------------ Request ------------------------
URL:\t\t\t$url
Parameters:\t\t${JsonEncoder.withIndent('  ').convert(parameters)}
---------------------------------------------------------
  ''');
  }

  static void printResponse(String url, Map response) {
    print('''
  
----------------------- Response ------------------------
URL:\t\t\t$url
Response:\t\t${JsonEncoder.withIndent('  ').convert(response)}
---------------------------------------------------------
  ''');
  }
}
