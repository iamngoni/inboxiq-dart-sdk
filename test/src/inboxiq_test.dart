//
//  inboxiq
//  inboxiq_test.dart
//
//  This codebase is not affiliated to InboxIQ
//
//  Created by Ngonidzashe Mangudya on 25/01/2025.
//  Copyright (c) 2025 Codecraft Solutions
//  Licensed under the MIT License
//  https://codecraftsolutions.co.za
//

import 'package:inboxiq/inboxiq.dart';
import 'package:test/test.dart';

void main() {
  group('InboxIQ', () {
    test('can be instantiated', () {
      final inboxiq = InboxIQ.initialize(
        username: 'test-user',
        password: 'test-pass',
        apiKey: 'test-key',
      );
      expect(inboxiq, isNotNull);
    });
  });

  group('SendEmailRequest', () {
    test('toJson returns correct map', () {
      const request = SendEmailRequest(
        toRecipients: ['user@example.com'],
        subject: 'Test Subject',
        body: '<p>Test body</p>',
        from: 'sender@example.com',
        applicationId: 123,
      );

      final json = request.toJson();

      expect(json['toRecipients'], ['user@example.com']);
      expect(json['subject'], 'Test Subject');
      expect(json['body'], '<p>Test body</p>');
      expect(json['from'], 'sender@example.com');
      expect(json['applicationId'], 123);
      expect(json['plainText'], false);
      expect(json.containsKey('personalName'), false);
      expect(json.containsKey('attachments'), false);
    });

    test('toJson includes optional fields when provided', () {
      const request = SendEmailRequest(
        toRecipients: ['user@example.com'],
        subject: 'Test Subject',
        body: 'Plain text body',
        from: 'sender@example.com',
        applicationId: 123,
        plainText: true,
        personalName: 'John Doe',
        attachments: [
          Attachment(
            name: 'file.pdf',
            fileSourceUrl: 'https://example.com/file.pdf',
          ),
        ],
      );

      final json = request.toJson();

      expect(json['plainText'], true);
      expect(json['personalName'], 'John Doe');
      expect(json['attachments'], isA<List<Map<String, dynamic>>>());
      final List<Map<String, dynamic>> attachments =
          json['attachments'] as List<Map<String, dynamic>>;
      expect(attachments[0]['name'], 'file.pdf');
    });
  });

  group('SendSmsRequest', () {
    test('toJson returns correct map', () {
      const request = SendSmsRequest(
        phoneNumber: '+263771234567',
        message: 'Test message',
        applicationId: 123,
      );

      final json = request.toJson();

      expect(json['phoneNumber'], '+263771234567');
      expect(json['message'], 'Test message');
      expect(json['applicationId'], 123);
    });
  });

  group('Attachment', () {
    test('toJson returns correct map', () {
      const attachment = Attachment(
        name: 'document.pdf',
        fileSourceUrl: 'https://example.com/document.pdf',
      );

      final json = attachment.toJson();

      expect(json['name'], 'document.pdf');
      expect(json['fileSourceUrl'], 'https://example.com/document.pdf');
    });
  });

  group('Result', () {
    test('Success contains data', () {
      final Result<String> result = Result.success('test data');

      expect(result.isSuccess, true);
      expect(result.isError, false);
      expect(result.dataOrNull, 'test data');
      expect(result.errorOrNull, isNull);
    });

    test('Error contains exception', () {
      const exception = InboxIQException(
        message: 'Test error',
        statusCode: 400,
      );
      final Result<String> result = Result.error(exception);

      expect(result.isSuccess, false);
      expect(result.isError, true);
      expect(result.dataOrNull, isNull);
      expect(result.errorOrNull, exception);
    });

    test('map transforms success value', () {
      final Result<int> result = Result.success(5);
      final Result<String> mapped = result.map((n) => 'Number: $n');

      expect(mapped.dataOrNull, 'Number: 5');
    });

    test('map preserves error', () {
      const exception = InboxIQException(
        message: 'Test error',
        statusCode: 400,
      );
      final Result<int> result = Result.error(exception);
      final Result<String> mapped = result.map((n) => 'Number: $n');

      expect(mapped.isError, true);
      expect(mapped.errorOrNull, exception);
    });

    test('when executes correct callback', () {
      final Result<String> success = Result.success('data');
      final Result<String> error = Result.error(
        const InboxIQException(message: 'error', statusCode: 400),
      );

      final successResult = success.when(
        success: (data) => 'Got: $data',
        error: (e) => 'Error: ${e.message}',
      );

      final errorResult = error.when(
        success: (data) => 'Got: $data',
        error: (e) => 'Error: ${e.message}',
      );

      expect(successResult, 'Got: data');
      expect(errorResult, 'Error: error');
    });
  });

  group('InboxIQException', () {
    test('toString returns formatted string', () {
      const exception = InboxIQException(
        message: 'Test error',
        statusCode: 400,
        path: '/api/v1/send-email',
        timestamp: '2025-01-25',
      );

      expect(
        exception.toString(),
        contains('InboxIQException'),
      );
      expect(exception.toString(), contains('400'));
      expect(exception.toString(), contains('Test error'));
    });
  });
}
