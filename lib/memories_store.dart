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

  SavedTribute copyWith({
    String? id,
    String? templateId,
    String? backgroundAssetPath,
    String? heading,
    String? name,
    String? dates,
    String? message,
    Uint8List? photoBytes,
    bool clearPhoto = false,
    DateTime? createdAt,
  }) {
    return SavedTribute(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      backgroundAssetPath: backgroundAssetPath ?? this.backgroundAssetPath,
      heading: heading ?? this.heading,
      name: name ?? this.name,
      dates: dates ?? this.dates,
      message: message ?? this.message,
      photoBytes: clearPhoto ? null : (photoBytes ?? this.photoBytes),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class MemoriesStore {
  MemoriesStore._();

  static final ValueNotifier<List<SavedTribute>> savedTributes =
      ValueNotifier<List<SavedTribute>>(<SavedTribute>[]);

  static void add(SavedTribute tribute) {
    savedTributes.value = <SavedTribute>[tribute, ...savedTributes.value];
  }

  static void save(SavedTribute tribute) {
    final int index = savedTributes.value.indexWhere(
      (item) => item.id == tribute.id,
    );
    if (index == -1) {
      add(tribute);
      return;
    }

    final List<SavedTribute> next = List<SavedTribute>.from(
      savedTributes.value,
    );
    next[index] = tribute;
    savedTributes.value = next;
  }

  static void removeById(String id) {
    savedTributes.value = savedTributes.value
        .where((tribute) => tribute.id != id)
        .toList(growable: false);
  }
}
