//
//  inboxiq
//  webhook_test.dart
//
//  This codebase is not affiliated to InboxIQ
//
//  Created by Ngonidzashe Mangudya on 25/01/2025.
//  Copyright (c) 2025 Codecraft Solutions
//  Licensed under the MIT License
//  https://codecraftsolutions.co.za
//

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:inboxiq/inboxiq.dart';
import 'package:test/test.dart';

void main() {
  group('WebhookHandler', () {
    const String secret = 'test-webhook-secret';
    const handler = WebhookHandler(secret: secret);

    test('verifySignature returns true for valid signature', () {
      const String payload = '{"event":"email.delivered"}';
      final List<int> key = utf8.encode(secret);
      final List<int> bytes = utf8.encode(payload);
      final Hmac hmac = Hmac(sha256, key);
      final String signature = hmac.convert(bytes).toString();

      expect(handler.verifySignature(payload, signature), isTrue);
    });

    test('verifySignature returns false for invalid signature', () {
      const String payload = '{"event":"email.delivered"}';
      const String invalidSignature = 'invalid-signature';

      expect(handler.verifySignature(payload, invalidSignature), isFalse);
    });

    test('verifySignature returns false for null signature', () {
      const String payload = '{"event":"email.delivered"}';

      expect(handler.verifySignature(payload, null), isFalse);
    });

    test('verifySignature returns false for empty signature', () {
      const String payload = '{"event":"email.delivered"}';

      expect(handler.verifySignature(payload, ''), isFalse);
    });

    test('parseEvent parses email.delivered event', () {
      const String payload = '''
{
  "event": "email.delivered",
  "timestamp": "2025-01-23T14:30:00Z",
  "data": {
    "messageId": "msg_abc123def456",
    "recipient": "user@example.com",
    "subject": "Welcome to InboxIQ!",
    "deliveredAt": "2025-01-23T14:30:00Z",
    "status": "delivered"
  }
}
''';

      final WebhookEvent event = handler.parseEvent(payload);

      expect(event.event, WebhookEventType.emailDelivered);
      expect(event.timestamp, DateTime.utc(2025, 1, 23, 14, 30));
      expect(event.data.messageId, 'msg_abc123def456');
      expect(event.data.recipient, 'user@example.com');
      expect(event.data.subject, 'Welcome to InboxIQ!');
      expect(event.data.status, 'delivered');
    });

    test('parseEvent parses sms.failed event', () {
      const String payload = '''
{
  "event": "sms.failed",
  "timestamp": "2025-01-23T14:30:00Z",
  "data": {
    "messageId": "msg_sms123",
    "phoneNumber": "+263771234567",
    "errorMessage": "Invalid phone number"
  }
}
''';

      final WebhookEvent event = handler.parseEvent(payload);

      expect(event.event, WebhookEventType.smsFailed);
      expect(event.data.messageId, 'msg_sms123');
      expect(event.data.phoneNumber, '+263771234567');
      expect(event.data.errorMessage, 'Invalid phone number');
    });
  });

  group('WebhookEventType', () {
    test('fromString returns correct type', () {
      expect(
        WebhookEventType.fromString('email.delivered'),
        WebhookEventType.emailDelivered,
      );
      expect(
        WebhookEventType.fromString('email.bounced'),
        WebhookEventType.emailBounced,
      );
      expect(
        WebhookEventType.fromString('sms.delivered'),
        WebhookEventType.smsDelivered,
      );
    });

    test('fromString returns unknown for invalid type', () {
      expect(
        WebhookEventType.fromString('invalid.event'),
        WebhookEventType.unknown,
      );
    });
  });

  group('WebhookEvent', () {
    test('toJson returns correct map', () {
      final WebhookEvent event = WebhookEvent(
        event: WebhookEventType.emailDelivered,
        timestamp: DateTime.utc(2025, 1, 23, 14, 30),
        data: const WebhookEventData(
          messageId: 'msg_123',
          recipient: 'user@example.com',
          status: 'delivered',
        ),
      );

      final Map<String, dynamic> json = event.toJson();

      expect(json['event'], 'email.delivered');
      expect(json['timestamp'], '2025-01-23T14:30:00.000Z');
      final Map<String, dynamic> data = json['data'] as Map<String, dynamic>;
      expect(data['messageId'], 'msg_123');
    });
  });
}
