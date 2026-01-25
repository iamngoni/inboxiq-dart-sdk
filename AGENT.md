# Coding Guidelines

## File Header

Every Dart file must include a header comment:

```dart
//
//  inboxiq
//  file_name.dart
//
//  This codebase is not affiliated to InboxIQ
//
//  Created by Ngonidzashe Mangudya on DD/MM/YYYY.
//  Copyright (c) YYYY Codecraft Solutions
//  Licensed under the MIT License
//  https://codecraftsolutions.co.za
//
```

## Code Style

### Imports

- Use relative imports within the project (`prefer_relative_imports: true`)
- Order imports: dart, package, relative
- Separate import groups with blank lines

### Types

- Always declare return types (`always_declare_return_types: true`)
- Avoid dynamic calls (`avoid_dynamic_calls: true`)
- Use strict casts and strict raw types
- Don't use `toString()` for type checking (`avoid_type_to_string: true`)

### Variables

- Don't omit local variable types (`omit_local_variable_types: false`)
- Prefer explicit type declarations for clarity

### Classes

- Use private constructors with factory methods for initialization:

```dart
class MyClass {
  MyClass._({required this.param});

  factory MyClass.initialize({required String param}) =>
      MyClass._(param: param);

  final String param;
}
```

- Use `sealed class` for Result/Either patterns
- Use `final class` for concrete implementations

### Error Handling

- Create custom exception classes that implement `Exception`
- Use Result pattern for operations that can fail:

```dart
sealed class Result<T> {
  const Result();
  factory Result.success(T data) = Success<T>;
  factory Result.error(MyException error) = Error<T>;
}
```

- Provide `when`, `map`, and `flatMap` methods for Result types

### Documentation

- Document public APIs with `///` doc comments
- Include usage examples in documentation
- Use `##` sections for Parameters, Returns, Example

### Naming

- Use descriptive names
- Prefix private members with underscore
- Use `camelCase` for variables and methods
- Use `PascalCase` for classes and types

## Project Structure

```
lib/
├── src/
│   ├── models/         # Data models and exceptions
│   ├── utils/          # Helper functions and constants
│   └── [feature].dart  # Main feature implementation
└── [project].dart      # Public API exports
test/
└── src/
    └── [feature]_test.dart
```

## Testing

- Place tests in `test/src/` mirroring the lib structure
- Use descriptive test names
- Group related tests with `group()`

## Dependencies

- Use `very_good_analysis` for linting
- Configure `json_serializable` with:
  - `include_if_null: false`
  - `explicit_to_json: true`
