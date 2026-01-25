//
//  inboxiq
//  send_sms_request.dart
//
//  This codebase is not affiliated to InboxIQ
//
//  Created by Ngonidzashe Mangudya on 25/01/2025.
//  Copyright (c) 2025 Codecraft Solutions
//  Licensed under the MIT License
//  https://codecraftsolutions.co.za
//

/// Request model for sending an SMS via InboxIQ API.
class SendSmsRequest {
  const SendSmsRequest({
    required this.phoneNumber,
    required this.message,
    required this.applicationId,
  });

  /// The recipient phone number.
  final String phoneNumber;

  /// The SMS message content.
  final String message;

  /// Your application ID from the dashboard.
  final int applicationId;

  /// Converts this request to a JSON map.
  Map<String, dynamic> toJson() => {
    'phoneNumber': phoneNumber,
    'message': message,
    'applicationId': applicationId,
  };
}
