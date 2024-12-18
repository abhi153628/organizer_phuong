import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

class EventLocationModel {
  final String locationName;
  final double latitude;
  final double longitude;
  final String fullAddress;
  final GeoPoint geoPoint;

  EventLocationModel({
    required this.locationName,
    required this.latitude, 
    required this.longitude,
    required this.fullAddress,
    required this.geoPoint,
  });

  // Convert to Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'locationName': locationName,
      'latitude': latitude,
      'longitude': longitude,
      'fullAddress': fullAddress,
      'geoPoint': GeoPoint(latitude, longitude),
    };
  }

  // Create from Firestore document
  factory EventLocationModel.fromMap(Map<String, dynamic> map) {
    return EventLocationModel(
      locationName: map['locationName'] ?? '',
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
      fullAddress: map['fullAddress'] ?? '',
      geoPoint: map['geoPoint'] ?? GeoPoint(0, 0),
    );
  }
}

// Updated Location Field Widget
class EnhancedLocationField extends StatefulWidget {
  final Function(EventLocationModel) onLocationSelected;

  const EnhancedLocationField({
    Key? key, 
    required this.onLocationSelected
  }) : super(key: key);

  @override
  _EnhancedLocationFieldState createState() => _EnhancedLocationFieldState();
}

class _EnhancedLocationFieldState extends State<EnhancedLocationField> {
  final TextEditingController _locationController = TextEditingController();
  EventLocationModel? _selectedLocation;

  void _showLocationPickerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Location'),
          content: GooglePlaceAutoCompleteTextField(
            textEditingController: _locationController,
            googleAPIKey: "AIzaSyCrEye_u6VwYQpCIp8eOBgGj71MThkQCDE",
            isLatLngRequired: true,
            getPlaceDetailWithLatLng: (prediction) {
              // Create location model when place is selected
              final locationModel = EventLocationModel(
                locationName: prediction.description ?? '',
                latitude: double.parse(prediction.lat ?? '0'),
                longitude: double.parse(prediction.lng ?? '0'),
                fullAddress: prediction.description ?? '',
                geoPoint: GeoPoint(
                  double.parse(prediction.lat ?? '0'),
                  double.parse(prediction.lng ?? '0')
                ),
              );

              // Update UI and notify parent
              setState(() {
                _selectedLocation = locationModel;
                _locationController.text = locationModel.locationName;
              });

              widget.onLocationSelected(locationModel);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 50,width: 400,

      child: TextFormField(
        controller: _locationController,
        readOnly: true,
        onTap: _showLocationPickerDialog,
        decoration: InputDecoration(
          hintText: 'Select Location',
          suffixIcon: IconButton(
            icon: Icon(Icons.location_on),
            onPressed: _showLocationPickerDialog,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a location';
          }
          return null;
        },
      ),
    );
  }
}