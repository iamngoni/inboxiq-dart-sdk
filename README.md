# InboxIQ

A Dart SDK for the [InboxIQ](https://inboxiq.co.zw) email and SMS API.

> **Disclaimer:** This codebase is not affiliated with InboxIQ.

## Installation

Add `inboxiq` to your `pubspec.yaml`:

```yaml
dependencies:
  inboxiq:
    git:
      url: https://github.com/your-username/inboxiq.git
```

## Usage

### Initialize the client

```dart
import 'package:inboxiq/inboxiq.dart';

final inboxiq = InboxIQ.initialize(
  username: 'your-username',
  password: 'your-password',
  apiKey: 'your-api-key',
);
```

### Send an email

```dart
final result = await inboxiq.sendEmail(
  SendEmailRequest(
    toRecipients: ['user@example.com'],
    subject: 'Welcome to InboxIQ!',
    body: '<h1>Hello!</h1><p>Welcome to our platform.</p>',
    from: 'noreply@yourdomain.com',
    applicationId: 123,
    personalName: 'John Doe',
  ),
);

switch (result) {
  case Success():
    print('Email queued successfully');
  case Error(:final error):
    print('Failed: ${error.message}');
}
```

### Send an email with attachments

```dart
final result = await inboxiq.sendEmail(
  SendEmailRequest(
    toRecipients: ['user@example.com'],
    subject: 'Your Invoice',
    body: '<p>Please find your invoice attached.</p>',
    from: 'billing@yourdomain.com',
    applicationId: 123,
    attachments: [
      Attachment(
        name: 'invoice.pdf',
        fileSourceUrl: 'https://yourdomain.com/files/invoice.pdf',
      ),
    ],
  ),
);
```

### Send an SMS

```dart
final result = await inboxiq.sendSms(
  SendSmsRequest(
    phoneNumber: '+263771234567',
    message: 'Your verification code is 123456',
    applicationId: 123,
  ),
);

switch (result) {
  case Success():
    print('SMS sent successfully');
  case Error(:final error):
    print('Failed: ${error.message}');
}
```

## API Reference

### InboxIQ

| Method | Description |
|--------|-------------|
| `sendEmail(SendEmailRequest)` | Send an email to one or more recipients |
| `sendSms(SendSmsRequest)` | Send an SMS to a phone number |

### SendEmailRequest

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `toRecipients` | `List<String>` | Yes | Array of recipient email addresses |
| `subject` | `String` | Yes | Email subject line |
| `body` | `String` | Yes | Email body (HTML or plain text) |
| `from` | `String` | Yes | Sender email (must be verified) |
| `applicationId` | `int` | Yes | Your application ID from dashboard |
| `plainText` | `bool` | No | Send as plain text (default: false) |
| `personalName` | `String` | No | Sender's display name |
| `attachments` | `List<Attachment>` | No | Email attachments |

### SendSmsRequest

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `phoneNumber` | `String` | Yes | Recipient phone number |
| `message` | `String` | Yes | SMS message content |
| `applicationId` | `int` | Yes | Your application ID from dashboard |

### Attachment

| Parameter | Type | Description |
|-----------|------|-------------|
| `name` | `String` | Attachment file name |
| `fileSourceUrl` | `String` | URL where the file is hosted |

## Error Handling

The SDK uses a `Result` type for error handling:

```dart
final result = await inboxiq.sendEmail(request);

// Pattern matching
switch (result) {
  case Success():
    // Handle success
  case Error(:final error):
    print('Error ${error.statusCode}: ${error.message}');
}

// Or use helper methods
if (result.isSuccess) {
  // Handle success
}

if (result.isError) {
  final error = result.errorOrNull;
  print('Error: ${error?.message}');
}

// Or use when
result.when(
  success: (_) => print('Success!'),
  error: (e) => print('Error: ${e.message}'),
);
```

### Error Codes

| Code | Description |
|------|-------------|
| 400 | Bad Request - Missing or invalid parameters |
| 401 | Unauthorized - Invalid credentials |
| 403 | Forbidden - Insufficient permissions or credits |
| 404 | Not Found - Resource or endpoint not found |
| 429 | Too Many Requests - Rate limit exceeded |
| 500 | Server Error |

## License

MIT License - see [LICENSE](LICENSE) for details.
