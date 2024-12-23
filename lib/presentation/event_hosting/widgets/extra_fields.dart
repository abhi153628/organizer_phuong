import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';


class EventNameField extends StatelessWidget {
  final TextEditingController controller;
  final bool isLocationFieldActive;

  const EventNameField({
    Key? key,
    required this.controller,
    required this.isLocationFieldActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Name', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: !isLocationFieldActive,
          decoration: InputDecoration(
            hintText: "Event Name",
            hintStyle: TextStyle(
                color: isLocationFieldActive
                    ? Colors.grey.withOpacity(0.5)
                    : Colors.grey),
            filled: true,
            fillColor: grey.withOpacity(isLocationFieldActive ? 0.1 : 0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your Event name';
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: const TextStyle(color: Colors.white),
          enableInteractiveSelection: !isLocationFieldActive,
          readOnly: isLocationFieldActive,
        ),
      ],
    );
  }
}

class DateTimeFields extends StatelessWidget {
  final TextEditingController dateController;
  final TextEditingController timeController;
  final bool isLocationFieldActive;
  final Function() onDateTap;
  final Function() onTimeTap;

  const DateTimeFields({
    Key? key,
    required this.dateController,
    required this.timeController,
    required this.isLocationFieldActive,
    required this.onDateTap,
    required this.onTimeTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Date', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 8),
              TextFormField(
                controller: dateController,
                enabled: !isLocationFieldActive,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Select Date",
                  hintStyle: TextStyle(
                      color: isLocationFieldActive
                          ? Colors.grey.withOpacity(0.5)
                          : Colors.grey),
                  filled: true,
                  fillColor: grey.withOpacity(isLocationFieldActive ? 0.1 : 0.2),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today,
                        color: isLocationFieldActive
                            ? purple.withOpacity(0.5)
                            : purple),
                    onPressed: isLocationFieldActive ? null : onDateTap,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select date';
                  }
                  return null;
                },
                style: const TextStyle(color: Colors.white),
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Time', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 8),
              TextFormField(
                controller: timeController,
                enabled: !isLocationFieldActive,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Select Time",
                  hintStyle: TextStyle(
                      color: isLocationFieldActive
                          ? Colors.grey.withOpacity(0.5)
                          : Colors.grey),
                  filled: true,
                  fillColor: grey.withOpacity(isLocationFieldActive ? 0.1 : 0.2),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.access_time,
                        color: isLocationFieldActive
                            ? purple.withOpacity(0.5)
                            : purple),
                    onPressed: isLocationFieldActive ? null : onTimeTap,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select time';
                  }
                  return null;
                },
                style: const TextStyle(color: Colors.white),
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DescriptionField extends StatelessWidget {
  final TextEditingController controller;
  final bool isLocationFieldActive;

  const DescriptionField({
    Key? key,
    required this.controller,
    required this.isLocationFieldActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Description', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: !isLocationFieldActive,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Tell what your show is about",
            hintStyle: TextStyle(
                color: isLocationFieldActive
                    ? Colors.grey.withOpacity(0.5)
                    : Colors.grey),
            filled: true,
            fillColor: grey.withOpacity(isLocationFieldActive ? 0.1 : 0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Colors.white),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please provide a description';
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          enableInteractiveSelection: !isLocationFieldActive,
          readOnly: isLocationFieldActive,
        ),
      ],
    );
  }
}

class LocationField extends StatelessWidget {
  final TextEditingController controller;
  final Function(bool) onFocusChange;
  final Function(Prediction) onItemClick;

  const LocationField({
    Key? key,
    required this.controller,
    required this.onFocusChange,
    required this.onItemClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Location', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        Focus(
          onFocusChange: onFocusChange,
          child: GooglePlaceAutoCompleteTextField(
            textEditingController: controller,
            googleAPIKey: "AIzaSyCrEye_u6VwYQpCIp8eOBgGj71MThkQCDE",
            inputDecoration: InputDecoration(
              hintText: 'Add Location',
              hintStyle: GoogleFonts.aBeeZee(
                color: white,
                fontWeight: FontWeight.w300,
              ),
              filled: true,
              fillColor: grey.withOpacity(0.1),
              prefixIcon: Icon(Icons.location_on, color: purple),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: grey.withOpacity(0.9)),
              ),
            ),
            debounceTime: 400,
            countries: ["IN"],
            isLatLngRequired: true,
            getPlaceDetailWithLatLng: (postalCodeResponse) => true,
            itemClick: onItemClick,
            textStyle: GoogleFonts.aBeeZee(
              color: white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}

class EventDurationField extends StatelessWidget {
  final TextEditingController controller;
  final bool isLocationFieldActive;

  const EventDurationField({
    Key? key,
    required this.controller,
    required this.isLocationFieldActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Event Duration', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: !isLocationFieldActive,
          decoration: InputDecoration(
            hintText: "Duration in hours (e.g., 2 hours)",
            hintStyle: TextStyle(
                color: isLocationFieldActive
                    ? Colors.grey.withOpacity(0.5)
                    : Colors.grey),
            filled: true,
            fillColor: grey.withOpacity(isLocationFieldActive ? 0.1 : 0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              if (!RegExp(r'^\d+(\s+hours|\s+minutes)?$').hasMatch(value)) {
                return 'Please enter a valid duration (e.g., 2 hours or 30 minutes)';
              }
            }
            return null;
          },
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          enableInteractiveSelection: !isLocationFieldActive,
          readOnly: isLocationFieldActive,
        ),
      ],
    );
  }
}

class TicketPriceAndSeatsField extends StatelessWidget {
  final TextEditingController priceController;
  final TextEditingController seatsController;
  final bool isLocationFieldActive;

  const TicketPriceAndSeatsField({
    Key? key,
    required this.priceController,
    required this.seatsController,
    required this.isLocationFieldActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Price', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 8),
              TextFormField(
                controller: priceController,
                enabled: !isLocationFieldActive,
                decoration: InputDecoration(
                  hintText: "Ticket Price",
                  hintStyle: TextStyle(
                      color: isLocationFieldActive
                          ? Colors.grey.withOpacity(0.5)
                          : Colors.grey),
                  filled: true,
                  fillColor: grey.withOpacity(isLocationFieldActive ? 0.1 : 0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the ticket price';
                  }
                  if (!RegExp(r'^\d+$').hasMatch(value)) {
                    return 'Please enter a valid Price';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                enableInteractiveSelection: !isLocationFieldActive,
                readOnly: isLocationFieldActive,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Seat Availability',
                  style: TextStyle(color: Colors.white)),
              const SizedBox(height: 8),
              TextFormField(
                controller: seatsController,
                enabled: !isLocationFieldActive,
                decoration: InputDecoration(
                  hintText: "Enter seat availability",
                  hintStyle: TextStyle(
                      color: isLocationFieldActive
                          ? Colors.grey.withOpacity(0.5)
                          : Colors.grey),
                  filled: true,
                  fillColor: grey.withOpacity(isLocationFieldActive ? 0.1 : 0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the seat availability';
                  }
                  if (!RegExp(r'^\d+$').hasMatch(value)) {
                    return 'Please enter a valid number of seats';
                  }
                  if (int.parse(value) <= 0) {
                    return 'Seat availability must be greater than zero';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                enableInteractiveSelection: !isLocationFieldActive,
                readOnly: isLocationFieldActive,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ContactFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController facebookController;
  final TextEditingController instagramController;
  final bool isLocationFieldActive;

  const ContactFields({
    Key? key,
    required this.emailController,
    required this.facebookController,
    required this.instagramController,
    required this.isLocationFieldActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildEmailField(),
        const SizedBox(height: 28),
        _buildFacebookField(),
        const SizedBox(height: 28),
        _buildInstagramField(),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Email', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextFormField(
          controller: emailController,
          enabled: !isLocationFieldActive,
          decoration: InputDecoration(
            hintText: "Your Email",
            hintStyle: TextStyle(
                color: isLocationFieldActive
                    ? Colors.grey.withOpacity(0.5)
                    : Colors.grey),
            filled: true,
            fillColor: grey.withOpacity(isLocationFieldActive ? 0.1 : 0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.white),
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }

  Widget _buildFacebookField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Facebook', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextFormField(
          controller: facebookController,
          enabled: !isLocationFieldActive,
          decoration: InputDecoration(
            hintText: "Facebook Profile Link",
            hintStyle: TextStyle(
                color: isLocationFieldActive
                    ? Colors.grey.withOpacity(0.5)
                    : Colors.grey),
            filled: true,
            fillColor: grey.withOpacity(isLocationFieldActive ? 0.1 : 0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Colors.white),
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }

  Widget _buildInstagramField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Instagram', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextFormField(
          controller: instagramController,
          enabled: !isLocationFieldActive,
          decoration: InputDecoration(
            hintText: "Instagram Profile Link",
            hintStyle: TextStyle(
                color: isLocationFieldActive
                    ? Colors.grey.withOpacity(0.5)
                    : Colors.grey),
            filled: true,
            fillColor: grey.withOpacity(isLocationFieldActive ? 0.1 : 0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Colors.white),
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }
}
