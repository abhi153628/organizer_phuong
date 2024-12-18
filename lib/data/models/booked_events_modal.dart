import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String? bookingId;
  final String eventId;
  final String userId;
  final String userName;
  final int seatsBooked;
  final double totalPrice;
  final DateTime bookingTime;
  final String eventName;
  final String organizerId;

  BookingModel({
    this.bookingId,
    required this.eventId,
    required this.userId,
    required this.userName,
    required this.seatsBooked,
    required this.totalPrice,
    required this.bookingTime,
    required this.eventName,
    required this.organizerId,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'eventId': eventId,
      'userId': userId,
      'userName': userName,
      'seatsBooked': seatsBooked,
      'totalPrice': totalPrice,
      'bookingTime': bookingTime,
      'eventName': eventName,
      'organizerId': organizerId,
    };
  }

  // Create from Firestore document with improved null handling
  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      bookingId: map['bookingId'] as String?,
      eventId: map['eventId'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      userName: map['userName'] as String? ?? 'Unknown User',
      seatsBooked: (map['seatsBooked'] as num?)?.toInt() ?? 0,
      totalPrice: _parseDouble(map['totalPrice']),
      bookingTime: _parseDateTime(map['bookingTime']),
      eventName: map['eventName'] as String? ?? 'Unnamed Event',
      organizerId: map['organizerId'] as String? ?? '',
    );
  }

  // Helper method to safely parse double
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  // Helper method to safely parse DateTime
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.now();
  }

  // Method to create a copy with optional parameter changes
  BookingModel copyWith({
    String? bookingId,
    String? eventId,
    String? userId,
    String? userName,
    int? seatsBooked,
    double? totalPrice,
    DateTime? bookingTime,
    String? eventName,
    String? organizerId,
  }) {
    return BookingModel(
      bookingId: bookingId ?? this.bookingId,
      eventId: eventId ?? this.eventId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      seatsBooked: seatsBooked ?? this.seatsBooked,
      totalPrice: totalPrice ?? this.totalPrice,
      bookingTime: bookingTime ?? this.bookingTime,
      eventName: eventName ?? this.eventName,
      organizerId: organizerId ?? this.organizerId,
    );
  }
}