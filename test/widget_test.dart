import 'package:flutter_llm/domain/entities/message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Message', () {
    test('creates user message', () {
      final message = Message(text: 'Hello', isUser: true);

      expect(message.text, 'Hello');
      expect(message.isUser, true);
    });

    test('creates assistant message', () {
      final message = Message(text: 'Hi there', isUser: false);

      expect(message.text, 'Hi there');
      expect(message.isUser, false);
    });

    test('copyWith updates text', () {
      final original = Message(text: 'Hello', isUser: false);
      final updated = original.copyWith(text: 'Hello world');

      expect(updated.text, 'Hello world');
      expect(updated.isUser, false);
    });

    test('copyWith preserves fields when not specified', () {
      final original = Message(text: 'Hello', isUser: true);
      final updated = original.copyWith();

      expect(updated.text, 'Hello');
      expect(updated.isUser, true);
    });
  });
}
