class LocationModel {
  final String placeId;
  final String address;
  final double latitude;
  final double longitude;

  LocationModel({
    required this.placeId,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  // Optional: Convert to map for easy storage/serialization
  Map<String, dynamic> toMap() {
    return {
      'placeId': placeId,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}