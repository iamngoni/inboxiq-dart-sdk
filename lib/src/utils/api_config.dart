//
//  inboxiq
//  api_config.dart
//
//  This codebase is not affiliated to InboxIQ
//
//  Created by Ngonidzashe Mangudya on 25/01/2025.
//  Copyright (c) 2025 Codecraft Solutions
//  Licensed under the MIT License
//  https://codecraftsolutions.co.za
//

/// API configuration constants for InboxIQ.
abstract final class ApiConfig {
  /// The base URL for the InboxIQ API.
  static const String baseUrl = 'https://api.inboxiq.co.zw';

  /// The endpoint for sending emails.
  static const String sendEmailPath = '/api/v1/send-email';

  /// The endpoint for sending SMS.
  static const String sendSmsPath = '/api/v1/send-sms';
}
