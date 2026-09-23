class CrStop {
  const CrStop({
    required this.id,
    required this.name,
    required this.landmark,
    required this.lat,
    required this.lng,
    this.radiusMeters = 100,
  });

  final String id;
  final String name;
  final String landmark;
  final double lat;
  final double lng;
  final int radiusMeters;
}
