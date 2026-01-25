//
//  inboxiq
//  attachment.dart
//
//  This codebase is not affiliated to InboxIQ
//
//  Created by Ngonidzashe Mangudya on 25/01/2025.
//  Copyright (c) 2025 Codecraft Solutions
//  Licensed under the MIT License
//  https://codecraftsolutions.co.za
//

/// Represents an email attachment.
class Attachment {
  const Attachment({
    required this.name,
    required this.fileSourceUrl,
  });

  /// The name of the attachment file.
  final String name;

  /// The URL where the attachment file is hosted.
  final String fileSourceUrl;

  /// Converts this attachment to a JSON map.
  Map<String, dynamic> toJson() => {
    'name': name,
    'fileSourceUrl': fileSourceUrl,
  };
}
