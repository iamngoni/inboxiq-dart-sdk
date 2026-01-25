//
//  inboxiq
//  send_email_request.dart
//
//  This codebase is not affiliated to InboxIQ
//
//  Created by Ngonidzashe Mangudya on 25/01/2025.
//  Copyright (c) 2025 Codecraft Solutions
//  Licensed under the MIT License
//  https://codecraftsolutions.co.za
//

import 'attachment.dart';

/// Request model for sending an email via InboxIQ API.
class SendEmailRequest {
  const SendEmailRequest({
    required this.toRecipients,
    required this.subject,
    required this.body,
    required this.from,
    required this.applicationId,
    this.plainText = false,
    this.personalName,
    this.attachments,
  });

  /// Array of recipient email addresses.
  final List<String> toRecipients;

  /// Email subject line.
  final String subject;

  /// Email body content (HTML or plain text).
  final String body;

  /// Sender email address (must be verified in your account).
  final String from;

  /// Your application ID from the dashboard.
  final int applicationId;

  /// If true, sends as plain text. Default: false (HTML).
  final bool plainText;

  /// Sender's display name.
  final String? personalName;

  /// Array of attachment objects.
  final List<Attachment>? attachments;

  /// Converts this request to a JSON map.
  Map<String, dynamic> toJson() => {
    'toRecipients': toRecipients,
    'subject': subject,
    'body': body,
    'from': from,
    'applicationId': applicationId,
    'plainText': plainText,
    if (personalName != null) 'personalName': personalName,
    if (attachments != null)
      'attachments': attachments!.map((a) => a.toJson()).toList(),
  };
}
