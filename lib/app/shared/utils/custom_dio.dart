import 'package:dio/dio.dart';

BaseOptions options =  BaseOptions(
  baseUrl: 'https://www.example.com',
  //baseUrl: 'http://www.example.com',
  connectTimeout: const Duration(milliseconds: 10000),
  receiveTimeout: const Duration(milliseconds: 10000),

);
var dio = Dio(options);
