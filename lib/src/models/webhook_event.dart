//
//  inboxiq
//  webhook_event.dart
//
//  This codebase is not affiliated to InboxIQ
//
//  Created by Ngonidzashe Mangudya on 25/01/2025.
//  Copyright (c) 2025 Codecraft Solutions
//  Licensed under the MIT License
//  https://codecraftsolutions.co.za
//

/// Represents the type of webhook event.
enum WebhookEventType {
  /// Email was successfully delivered.
  emailDelivered('email.delivered'),

  /// Email bounced (hard or soft).
  emailBounced('email.bounced'),

  /// Email was opened by recipient.
  emailOpened('email.opened'),

  /// Link in email was clicked.
  emailClicked('email.clicked'),

  /// SMS was successfully delivered.
  smsDelivered('sms.delivered'),

  /// SMS delivery failed.
  smsFailed('sms.failed'),

  /// Unknown event type.
  unknown('unknown');

  const WebhookEventType(this.value);

  /// The string value of the event type.
  final String value;

  /// Creates a [WebhookEventType] from a string value.
  static WebhookEventType fromString(String value) {
    return WebhookEventType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => WebhookEventType.unknown,
    );
  }
}

/// Represents a webhook event from InboxIQ.
class WebhookEvent {
  const WebhookEvent({
    required this.event,
    required this.timestamp,
    required this.data,
  });

  /// Creates a [WebhookEvent] from a JSON map.
  factory WebhookEvent.fromJson(Map<String, dynamic> json) {
    return WebhookEvent(
      event: WebhookEventType.fromString(json['event'] as String? ?? ''),
      timestamp: DateTime.parse(json['timestamp'] as String),
      data: WebhookEventData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  /// The type of webhook event.
  final WebhookEventType event;

  /// The timestamp when the event occurred.
  final DateTime timestamp;

  /// The event data.
  final WebhookEventData data;

  /// Converts this event to a JSON map.
  Map<String, dynamic> toJson() => {
    'event': event.value,
    'timestamp': timestamp.toIso8601String(),
    'data': data.toJson(),
  };
}

/// Represents the data payload of a webhook event.
class WebhookEventData {
  const WebhookEventData({
    required this.messageId,
    this.recipient,
    this.subject,
    this.deliveredAt,
    this.status,
    this.phoneNumber,
    this.errorMessage,
    this.clickedUrl,
    this.openedAt,
    this.clickedAt,
    this.bouncedAt,
    this.bounceType,
  });

  /// Creates a [WebhookEventData] from a JSON map.
  factory WebhookEventData.fromJson(Map<String, dynamic> json) {
    return WebhookEventData(
      messageId: json['messageId'] as String,
      recipient: json['recipient'] as String?,
      subject: json['subject'] as String?,
      deliveredAt: json['deliveredAt'] != null
          ? DateTime.parse(json['deliveredAt'] as String)
          : null,
      status: json['status'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      errorMessage: json['errorMessage'] as String?,
      clickedUrl: json['clickedUrl'] as String?,
      openedAt: json['openedAt'] != null
          ? DateTime.parse(json['openedAt'] as String)
          : null,
      clickedAt: json['clickedAt'] != null
          ? DateTime.parse(json['clickedAt'] as String)
          : null,
      bouncedAt: json['bouncedAt'] != null
          ? DateTime.parse(json['bouncedAt'] as String)
          : null,
      bounceType: json['bounceType'] as String?,
    );
  }

  /// The unique message ID.
  final String messageId;

  /// The recipient email address (for email events).
  final String? recipient;

  /// The email subject (for email events).
  final String? subject;

  /// When the message was delivered.
  final DateTime? deliveredAt;

  /// The delivery status.
  final String? status;

  /// The recipient phone number (for SMS events).
  final String? phoneNumber;

  /// Error message (for failed events).
  final String? errorMessage;

  /// The URL that was clicked (for click events).
  final String? clickedUrl;

  /// When the email was opened.
  final DateTime? openedAt;

  /// When the link was clicked.
  final DateTime? clickedAt;

  /// When the email bounced.
  final DateTime? bouncedAt;

  /// The type of bounce (hard/soft).
  final String? bounceType;

  /// Converts this data to a JSON map.
  Map<String, dynamic> toJson() => {
    'messageId': messageId,
    if (recipient != null) 'recipient': recipient,
    if (subject != null) 'subject': subject,
    if (deliveredAt != null) 'deliveredAt': deliveredAt!.toIso8601String(),
    if (status != null) 'status': status,
    if (phoneNumber != null) 'phoneNumber': phoneNumber,
    if (errorMessage != null) 'errorMessage': errorMessage,
    if (clickedUrl != null) 'clickedUrl': clickedUrl,
    if (openedAt != null) 'openedAt': openedAt!.toIso8601String(),
    if (clickedAt != null) 'clickedAt': clickedAt!.toIso8601String(),
    if (bouncedAt != null) 'bouncedAt': bouncedAt!.toIso8601String(),
    if (bounceType != null) 'bounceType': bounceType,
  };
}
