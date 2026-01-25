//
//  inboxiq
//  inboxiq_exception.dart
//
//  This codebase is not affiliated to InboxIQ
//
//  Created by Ngonidzashe Mangudya on 25/01/2025.
//  Copyright (c) 2025 Codecraft Solutions
//  Licensed under the MIT License
//  https://codecraftsolutions.co.za
//

/// Exception class for InboxIQ API errors.
class InboxIQException implements Exception {
  const InboxIQException({
    required this.message,
    required this.statusCode,
    this.path,
    this.timestamp,
  });

  /// The error message.
  final String message;

  /// The HTTP status code associated with the error.
  final int statusCode;

  /// The API path that caused the error.
  final String? path;

  /// The timestamp of the error.
  final String? timestamp;

  @override
  String toString() {
    return 'InboxIQException(statusCode: $statusCode, message: $message, '
        'path: $path, timestamp: $timestamp)';
  }
}
