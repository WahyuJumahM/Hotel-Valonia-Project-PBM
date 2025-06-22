// lib/models/admin/tipe_kasur.dart
class TipeKasur {
  final int idTipeKasur;
  final String tipeKasur;

  TipeKasur({
    required this.idTipeKasur,
    required this.tipeKasur,
  });

  factory TipeKasur.fromJson(Map<String, dynamic> json) {
    return TipeKasur(
      idTipeKasur: json['id_Tipe_Kasur'] ?? 0,
      tipeKasur: json['tipe_Kasur'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_Tipe_Kasur': idTipeKasur,
      'tipe_Kasur': tipeKasur,
    };
  }

  // Untuk create request (tanpa id)
  Map<String, dynamic> toCreateJson() {
    return {
      'tipe_Kasur': tipeKasur,
    };
  }

  // Untuk update request
  Map<String, dynamic> toUpdateJson() {
    return {
      'id_Tipe_Kasur': idTipeKasur,
      'tipe_Kasur': tipeKasur,
    };
  }

  @override
  String toString() {
    return 'TipeKasur{idTipeKasur: $idTipeKasur, tipeKasur: $tipeKasur}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TipeKasur &&
          runtimeType == other.runtimeType &&
          idTipeKasur == other.idTipeKasur &&
          tipeKasur == other.tipeKasur;

  @override
  int get hashCode => idTipeKasur.hashCode ^ tipeKasur.hashCode;
}