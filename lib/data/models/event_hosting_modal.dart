import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventHostingModal {
  String? eventId;
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
      'time': time?.toString(), //  converting to a string format like HH:mm
      'uploadedImageUrl': uploadedImageUrl,
      'performanceType': performanceType,
      'genreType': genreType,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'eventRules': eventRules?.toList(), 
    };
  }

  //!  Convert Firestore Map to Event object

  factory EventHostingModal.fromMap(Map<String, dynamic> map) {
    return EventHostingModal(
      eventName: map['eventName'],
      eventId: map['eventId'], 
      organizerName: map['organizerName'],
      description: map['description'],
      ticketPrice: map['ticketPrice'],
      instagramLink: map['instagramLink'],
      facebookLink: map['facebookLink'],
      email: map['email'],
      seatAvailabilityCount: map['seatAvailabilityCount'],
      eventDurationTime: map['eventDurationTime'],
      specialInstruction: map['specialInstruction'],
      location: map['location'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      time: map['time'] != null ? TimeOfDayFromString.fromString(map['time']) : null, // extension for TimeOfDay
      uploadedImageUrl: map['uploadedImageUrl'],
      performanceType: map['performanceType'],
      genreType: map['genreType'],
      eventRules: map['eventRules'], 
    );
  }
}

extension TimeOfDayFromString on TimeOfDay {
  static TimeOfDay fromString(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }
}
