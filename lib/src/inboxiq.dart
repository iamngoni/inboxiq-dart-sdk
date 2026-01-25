//
//  inboxiq
//  inboxiq.dart
//
//  This codebase is not affiliated to InboxIQ
//
//  Created by Ngonidzashe Mangudya on 25/01/2025.
//  Copyright (c) 2025 Codecraft Solutions
//  Licensed under the MIT License
//  https://codecraftsolutions.co.za
//

import 'dart:convert';

import 'package:dio/dio.dart';

import 'models/inboxiq_exception.dart';
import 'models/result.dart';
import 'models/send_email_request.dart';
import 'models/send_sms_request.dart';
import 'utils/api_config.dart';

/// The main InboxIQ SDK class for integrating with InboxIQ email and SMS
/// services.
///
/// This class provides the core functionality for interacting with the InboxIQ
/// API for sending emails and SMS messages.
///
/// ## Usage
///
/// ```dart
/// final inboxiq = InboxIQ.initialize(
///   username: 'your-username',
///   password: 'your-password',
///   apiKey: 'your-api-key',
/// );
///
/// final result = await inboxiq.sendEmail(
///   SendEmailRequest(
///     toRecipients: ['user@example.com'],
///     subject: 'Hello',
///     body: '<h1>Welcome!</h1>',
///     from: 'noreply@yourdomain.com',
///     applicationId: 123,
///   ),
/// );
///
/// switch (result) {
///   case Success():
///     print('Email sent successfully');
///   case Error(:final error):
///     print('Failed: ${error.message}');
/// }
/// ```
class InboxIQ {
  InboxIQ._({
    required String username,
    required String password,
    required String apiKey,
    Dio? dio,
  }) : _apiKey = apiKey,
       _basicAuth = base64Encode(utf8.encode('$username:$password')),
       _dio = dio ?? Dio();

  /// Creates a new instance of the InboxIQ SDK.
  ///
  /// The [username] and [password] are used for Basic Authentication.
  /// The [apiKey] is sent as a header for API key authentication.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final inboxiq = InboxIQ.initialize(
  ///   username: 'your-username',
  ///   password: 'your-password',
  ///   apiKey: 'your-api-key',
  /// );
  /// ```
  factory InboxIQ.initialize({
    required String username,
    required String password,
    required String apiKey,
  }) => InboxIQ._(
    username: username,
    password: password,
    apiKey: apiKey,
  );

  final String _apiKey;
  final String _basicAuth;
  final Dio _dio;

  /// Sends an email using the InboxIQ API.
  ///
  /// ## Parameters
  ///
  /// - [request]: The email request containing all email details.
  ///
  /// ## Returns
  ///
  /// A [Result] containing `void` on success or an [InboxIQException] on error.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final request = SendEmailRequest(
  ///   toRecipients: ['user@example.com'],
  ///   subject: 'Welcome to InboxIQ!',
  ///   body: '<h1>Hello!</h1><p>Welcome to our platform.</p>',
  ///   from: 'noreply@yourdomain.com',
  ///   applicationId: 123,
  ///   personalName: 'John Doe',
  /// );
  ///
  /// final result = await inboxiq.sendEmail(request);
  /// switch (result) {
  ///   case Success():
  ///     print('Email queued successfully');
  ///   case Error(:final error):
  ///     print('Failed: ${error.message}');
  /// }
  /// ```
  Future<Result<void>> sendEmail(SendEmailRequest request) async {
    try {
      final Response<Map<String, dynamic>> response = await _dio.post(
        '${ApiConfig.baseUrl}${ApiConfig.sendEmailPath}',
        data: request.toJson(),
        options: Options(
          headers: _buildHeaders(),
        ),
      );

      if (response.statusCode == 200) {
        return Result.success(null);
      } else {
        return _createErrorResult(response);
      }
    } on DioException catch (e) {
      return _createDioErrorResult(e);
    } on Exception {
      return Result.error(
        const InboxIQException(
          message: 'Unexpected error occurred',
          statusCode: 500,
        ),
      );
    }
  }

  /// Sends an SMS using the InboxIQ API.
  ///
  /// ## Parameters
  ///
  /// - [request]: The SMS request containing phone number and message.
  ///
  /// ## Returns
  ///
  /// A [Result] containing `void` on success or an [InboxIQException] on error.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final request = SendSmsRequest(
  ///   phoneNumber: '+263771234567',
  ///   message: 'Your verification code is 123456',
  ///   applicationId: 123,
  /// );
  ///
  /// final result = await inboxiq.sendSms(request);
  /// switch (result) {
  ///   case Success():
  ///     print('SMS sent successfully');
  ///   case Error(:final error):
  ///     print('Failed: ${error.message}');
  /// }
  /// ```
  Future<Result<void>> sendSms(SendSmsRequest request) async {
    try {
      final Response<Map<String, dynamic>> response = await _dio.post(
        '${ApiConfig.baseUrl}${ApiConfig.sendSmsPath}',
        data: request.toJson(),
        options: Options(
          headers: _buildHeaders(),
        ),
      );

      if (response.statusCode == 200) {
        return Result.success(null);
      } else {
        return _createErrorResult(response);
      }
    } on DioException catch (e) {
      return _createDioErrorResult(e);
    } on Exception {
      return Result.error(
        const InboxIQException(
          message: 'Unexpected error occurred',
          statusCode: 500,
        ),
      );
    }
  }

  Map<String, String> _buildHeaders() => {
    'Content-Type': 'application/json',
    'Authorization': 'Basic $_basicAuth',
    'key': _apiKey,
  };

  Result<T> _createErrorResult<T>(Response<dynamic> response) {
    final int statusCode = response.statusCode ?? 500;
    final data = response.data;

    String message = _getErrorMessage(statusCode);
    String? path;
    String? timestamp;

    if (data is Map<String, dynamic>) {
      message = data['message']?.toString() ?? message;
      path = data['path']?.toString();
      timestamp = data['timestamp']?.toString();
    }

    return Result.error(
      InboxIQException(
        message: message,
        statusCode: statusCode,
        path: path,
        timestamp: timestamp,
      ),
    );
  }

  Result<T> _createDioErrorResult<T>(DioException e) {
    final int statusCode = e.response?.statusCode ?? 500;
    final data = e.response?.data;

    String message = _getErrorMessage(statusCode);
    String? path;
    String? timestamp;

    if (data is Map<String, dynamic>) {
      message = data['message']?.toString() ?? message;
      path = data['path']?.toString();
      timestamp = data['timestamp']?.toString();
    }

    return Result.error(
      InboxIQException(
        message: message,
        statusCode: statusCode,
        path: path,
        timestamp: timestamp,
      ),
    );
  }

  String _getErrorMessage(int statusCode) {
    return switch (statusCode) {
      400 => 'Bad Request: Missing or invalid parameters.',
      401 => 'Unauthorized: Invalid credentials.',
      403 => 'Forbidden: Insufficient permissions or credits.',
      404 => 'Not Found: Resource or endpoint not found.',
      429 => 'Too Many Requests: Rate limit exceeded.',
      _ => 'Server Error: Something went wrong.',
    };
  }
}
