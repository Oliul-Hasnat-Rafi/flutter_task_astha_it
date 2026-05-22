
import 'package:dio/dio.dart';
import 'package:flutter_task_astha_it/core/network/api_end_points.dart';
import 'package:flutter_task_astha_it/core/network/rest_client.dart';
import 'package:flutter_task_astha_it/features/sign_in/data/datasource/sign_in_datasource.dart';

class SignInDataSourceImp implements SignInDataSource {
  const SignInDataSourceImp({required this.restClient});

  final RestClient restClient;

  @override
  Future<Response> signIn({required Map<String, dynamic> requestBody}) async {
    final response = await restClient.post(
      APIType.PUBLIC,
      ApiEndPoints.signIn,
      requestBody,
    );

    return response;
  }
}
