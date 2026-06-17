class AppSettings {
  const AppSettings({
    this.id = defaultId,
    required this.halfDayValueCents,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppSettings.empty() {
    final now = DateTime.now();

    return AppSettings(halfDayValueCents: 0, createdAt: now, updatedAt: now);
  }

  factory AppSettings.fromMap(Map<String, Object?> map) {
    return AppSettings(
      id: map['id'] as int,
      halfDayValueCents: map['half_day_value_cents'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  static const defaultId = 1;

  final int id;
  final int halfDayValueCents;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'half_day_value_cents': halfDayValueCents,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  AppSettings copyWith({
    int? id,
    int? halfDayValueCents,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppSettings(
      id: id ?? this.id,
      halfDayValueCents: halfDayValueCents ?? this.halfDayValueCents,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
