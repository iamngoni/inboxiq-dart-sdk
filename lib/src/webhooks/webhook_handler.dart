//
//  inboxiq
//  webhook_handler.dart
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

import '../models/webhook_event.dart';

/// Handles InboxIQ webhook verification and parsing.
///
/// Use this class to verify incoming webhook requests and parse the payload.
///
/// ## Usage
///
/// ```dart
/// final handler = WebhookHandler(secret: 'your-webhook-secret');
///
/// // In your server route handler:
/// final signature = request.headers['x-inboxiq-signature'];
/// final body = await request.readAsString();
///
/// if (!handler.verifySignature(body, signature)) {
///   return Response(401, body: 'Invalid signature');
/// }
///
/// final event = handler.parseEvent(body);
/// switch (event.event) {
///   case WebhookEventType.emailDelivered:
///     print('Email delivered to ${event.data.recipient}');
///   case WebhookEventType.smsFailed:
///     print('SMS failed: ${event.data.errorMessage}');
///   // ...
/// }
/// ```
class WebhookHandler {
  const WebhookHandler({required this.secret});

  /// The webhook secret used for signature verification.
  final String secret;

  /// The header name for the webhook signature.
  static const String signatureHeader = 'x-inboxiq-signature';

  /// Verifies the webhook signature.
  ///
  /// Returns `true` if the signature is valid, `false` otherwise.
  ///
  /// ## Parameters
  ///
  /// - [payload]: The raw request body as a string.
  /// - [signature]: The signature from the `X-InboxIQ-Signature` header.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final isValid = handler.verifySignature(requestBody, signature);
  /// if (!isValid) {
  ///   return Response(401, body: 'Invalid signature');
  /// }
  /// ```
  bool verifySignature(String payload, String? signature) {
    if (signature == null || signature.isEmpty) {
      return false;
    }

    final List<int> key = utf8.encode(secret);
    final List<int> bytes = utf8.encode(payload);
    final Hmac hmac = Hmac(sha256, key);
    final Digest digest = hmac.convert(bytes);
    final String expectedSignature = digest.toString();

    return _secureCompare(signature, expectedSignature);
  }

  /// Parses a webhook payload into a [WebhookEvent].
  ///
  /// ## Parameters
  ///
  /// - [payload]: The raw request body as a string.
  ///
  /// ## Returns
  ///
  /// A [WebhookEvent] containing the parsed event data.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final event = handler.parseEvent(requestBody);
  /// print('Event type: ${event.event}');
  /// print('Message ID: ${event.data.messageId}');
  /// ```
  WebhookEvent parseEvent(String payload) {
    final Map<String, dynamic> json =
        jsonDecode(payload) as Map<String, dynamic>;
    return WebhookEvent.fromJson(json);
  }

  /// Parses a webhook payload from a JSON map.
  ///
  /// Use this if you've already parsed the JSON.
  WebhookEvent parseEventFromJson(Map<String, dynamic> json) {
    return WebhookEvent.fromJson(json);
  }

  /// Constant-time string comparison to prevent timing attacks.
  bool _secureCompare(String a, String b) {
    if (a.length != b.length) {
      return false;
    }

    int result = 0;
    for (int i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return result == 0;
  }
}
