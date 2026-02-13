import 'package:flutter/foundation.dart';

class SavedTribute {
  const SavedTribute({
    required this.id,
    required this.templateId,
    required this.backgroundAssetPath,
    required this.heading,
    required this.name,
    required this.dates,
    required this.message,
    required this.createdAt,
    this.photoBytes,
  });

  final String id;
  final String templateId;
  final String backgroundAssetPath;
  final String heading;
  final String name;
  final String dates;
  final String message;
  final Uint8List? photoBytes;
  final DateTime createdAt;
}

class MemoriesStore {
  MemoriesStore._();

  static final ValueNotifier<List<SavedTribute>> savedTributes =
      ValueNotifier<List<SavedTribute>>(<SavedTribute>[]);

  static void add(SavedTribute tribute) {
    savedTributes.value = <SavedTribute>[tribute, ...savedTributes.value];
  }

  static void removeById(String id) {
    savedTributes.value = savedTributes.value
        .where((tribute) => tribute.id != id)
        .toList(growable: false);
  }
}
