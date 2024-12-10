import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventHostingModal {
  String? eventId;
  String ?organizerId;
  String? eventName;
  String? organizerName;
  String? description;
  double? ticketPrice;
  String? instagramLink;
  String? facebookLink;
  String? email;
  double? seatAvailabilityCount;
  double? eventDurationTime;
  String? specialInstruction;
  String? location;
  DateTime? date;
  TimeOfDay? time;
  String? uploadedImageUrl;
  int? performanceType;
  String? genreType;
  List<String>? eventRules;

  EventHostingModal({
    this.eventId,
    this.organizerId,
    this.eventName,
    this.organizerName,
    this.description,
    this.ticketPrice,
    this.instagramLink,
    this.facebookLink,
    this.email,
    this.seatAvailabilityCount,
    this.eventDurationTime,
    this.specialInstruction,
    this.location,
    this.date,
    this.time,
    this.uploadedImageUrl,
    this.performanceType,
    this.genreType,
    this.eventRules,
  });

  //! Convert Event object to Map for saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'eventId': eventId,
      'organizerId': organizerId,
      'organizerName': organizerName,
      'description': description,
      'ticketPrice': ticketPrice,
      'instagramLink': instagramLink,
      'facebookLink': facebookLink,
      'email': email,
      'seatAvailabilityCount': seatAvailabilityCount,
      'eventDurationTime': eventDurationTime,
      'specialInstruction': specialInstruction,
      'location': location,
      'date': date?.toIso8601String(),
      'time': time?.toStorageString(), // Using the extension method
      'uploadedImageUrl': uploadedImageUrl,
      'performanceType': performanceType,
      'genreType': genreType,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'eventRules': eventRules,
    };
  }

  factory EventHostingModal.fromMap(Map<String, dynamic> map) {
    return EventHostingModal(
      eventName: map['eventName'],
      eventId: map['eventId'],
      organizerId: map['organizerId'],
      organizerName: map['organizerName'],
      description: map['description'],
      ticketPrice: (map['ticketPrice'] as num?)?.toDouble(),
      instagramLink: map['instagramLink'],
      facebookLink: map['facebookLink'],
      email: map['email'],
      seatAvailabilityCount: (map['seatAvailabilityCount'] as num?)?.toDouble(),
      eventDurationTime: (map['eventDurationTime'] as num?)?.toDouble(),
      specialInstruction: map['specialInstruction'],
      location: map['location'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      time: TimeOfDayConverter.fromString(
          map['time']), // Using the extension method
      uploadedImageUrl: map['uploadedImageUrl'],
      performanceType: map['performanceType'],
      genreType: map['genreType'],
      eventRules: List<String>.from(map['eventRules'] ?? []),
    );
  }
}

extension TimeOfDayConverter on TimeOfDay {
  String toStorageString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  static TimeOfDay? fromString(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      final parts = value.split(':');
      if (parts.length == 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (e) {
      print('Error parsing TimeOfDay: $e');
    }
    return null;
  }
}
