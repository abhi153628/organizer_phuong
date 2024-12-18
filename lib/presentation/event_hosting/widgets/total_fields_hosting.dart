import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/core/widgets/cstm_text.dart';
import 'package:phuong_for_organizer/core/widgets/transition.dart';
import 'package:phuong_for_organizer/data/dataresources/event_hosting_firebase_service.dart';
import 'package:phuong_for_organizer/data/dataresources/organizer_profile_adding_firebase_service.dart';
import 'package:phuong_for_organizer/data/models/event_hosting_modal.dart';
import 'package:phuong_for_organizer/data/models/organizer_profile_adding_modal.dart';
import 'package:phuong_for_organizer/presentation/event_hosting/widgets/adding_image_hosting.dart';
import 'package:phuong_for_organizer/presentation/event_hosting/widgets/genre_type_selecting_hosting.dart';
import 'package:phuong_for_organizer/presentation/event_hosting/widgets/glowing_button_hosting.dart';
import 'package:phuong_for_organizer/presentation/event_hosting/widgets/location_search_field.dart';
import 'package:phuong_for_organizer/presentation/event_hosting/widgets/select_event_type_hosting.dart';
import 'package:phuong_for_organizer/presentation/event_hosting/widgets/terms_and_condition_widget.dart';
import 'package:phuong_for_organizer/presentation/event_listing_page/event_listing_page.dart';

class TotalFields extends StatefulWidget {
  final Size size;

  const TotalFields({Key? key, required this.size}) : super(key: key);

  @override
  _TotalFieldsState createState() => _TotalFieldsState();
}

class _TotalFieldsState extends State<TotalFields> {
  final FirebaseEventService _eventService = FirebaseEventService();
  final OrganizerProfileAddingFirebaseService _firebaseService = OrganizerProfileAddingFirebaseService();
  // final String userId = FirebaseAuth.instance.currentUser!.uid;

  // check if any checkbox is selected
  int? _selectedEventTypeIndex;
  bool _isAnyCheckboxSelected() {
    return _selectedEventTypeIndex != null;
  }

  List<String> _eventRules = [];
  //!image
  XFile? _selectedImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _organizerNameController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ticketPriceController = TextEditingController();
  final TextEditingController _instagramLinkController =
      TextEditingController();
  final TextEditingController _facebookLinkController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _seatAvailabilityCountController =
      TextEditingController();
  final TextEditingController _eventDurationTimeController =
      TextEditingController();
  final TextEditingController _specialInstructionController =
      TextEditingController();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedGenre;
  final TextEditingController _locationController = TextEditingController();
LocationModel? _selectedLocation;

//! GENRE SELECTION
  void handleGenreSelection(String? genre) {
    setState(() {
      selectedGenre = genre;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            CstmText(
              text: 'Add Event Image',
              fontSize: 15,
              color: white,
            ),
            const SizedBox(
              height: 10,
            ),

            EventImage(
              size: widget.size,
              pickImage: (XFile image) {
                _selectedImage = image;
              },
            ),
              const SizedBox(height: 30),
            // **Event Basics**
                 buildLocationField(),
            const SizedBox(height: 28),
            _eventNameField(), // Event Name
            const SizedBox(height: 28),

            _buildDateTimeFields(), // time and date
            const SizedBox(height: 28),

            // **Event Details**
            _buildDescriptionField(), // Description
            const SizedBox(height: 28),
       
         
            _eventDurationTime(), // Duration
            const SizedBox(height: 28),
            _ticketAndSeatAvailabilityFields(), //ticket price and seat availiblity
            const SizedBox(height: 28),

            // **Performance Type and Genre**
            _buildPerformanceType(), // Performance Type
            const SizedBox(height: 28),
            genreTypeSelecting(), // Genre Type Selection

            // **Contact Information**
            _emailField(), // Email for Contact
            const SizedBox(height: 28),
            _facebookLinkField(), // Facebook Link
            const SizedBox(height: 28),
            _instagramLinkField(), // Instagram Link
            const SizedBox(height: 28),

            // **Special Instructions**
            _specialInstructionField(), // Special Instructions
            const SizedBox(height: 28),
            const Padding(
              padding: EdgeInsets.only(right: 180),
              child: Text(
                'Event Rules & Requirements',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            EventRulesInput(
              onRulesChanged: (List<String> updatedRules) {
                setState(() {
                  _eventRules = updatedRules;
                });
              },
            ),
            const SizedBox(height: 28),

            // **Submit Button**
            Center(child: _submitButton()), // Submit/Save Button
            const SizedBox(height: 28),
          ],
        ));
  }

  //! EVENT NAME FIELD
  Widget _eventNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Name', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _eventNameController,
          decoration: InputDecoration(
            hintText: "Event Name",
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: grey.withOpacity(0.2),
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
          enableInteractiveSelection: true,
          readOnly: false,
        ),
      ],
    );
  }

  //! DATE AND TIME FIELD
  Widget _buildDateTimeFields() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Date', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Select Date",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: grey.withOpacity(0.2),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today, color: purple),
                    onPressed: () => _selectDate(context),
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
                controller: _timeController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Select Time",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: grey.withOpacity(0.2),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.access_time, color: purple),
                    onPressed: () => _selectTime(context),
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

  //! EVENT DESCRIPTION  FIELD
  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Description', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Tell what your show is about",
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: grey.withOpacity(0.2),
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
          enableInteractiveSelection: true,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CstmText(text: '40', fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  //! LOCATION FIELD
Widget buildLocationField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Location',
        style: TextStyle(color: Colors.white)
      ),
      const SizedBox(height: 8),
      GooglePlaceAutoCompleteTextField(
        textEditingController: _locationController,
        googleAPIKey: "AIzaSyCrEye_u6VwYQpCIp8eOBgGj71MThkQCDE", // Replace with your actual key
        inputDecoration: InputDecoration(
          hintText: 'Add Location',
          hintStyle: GoogleFonts.aBeeZee(
            color: white,
            fontWeight: FontWeight.w300,
          ),
          filled: true,
          fillColor: grey.withOpacity(0.1),
          prefixIcon: Icon(
            Icons.location_on,
            color: purple,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: grey.withOpacity(0.9)),
          ),
        ),
        debounceTime: 400, // Wait 400ms after user stops typing
        countries: ["IN"], // Optional: Restrict to specific countries
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (postalCodeResponse) => true,
        
        // Modify the itemClick to prevent automatic focus change
        itemClick: (Prediction prediction) {
          // Explicitly set the text without losing focus
          _locationController.text = prediction.description ?? '';
          
          // Update selected location
          _selectedLocation = LocationModel(
            placeId: prediction.placeId ?? '',
            address: prediction.description ?? '',
            latitude: double.tryParse(prediction.lat ?? '0') ?? 0,
            longitude: double.tryParse(prediction.lng ?? '0') ?? 0,
          );
          
          // Optionally, dismiss the keyboard or autocomplete suggestions
          FocusScope.of(context).unfocus();
        },
        
        textStyle: GoogleFonts.aBeeZee(
          color: white,
          fontSize: 16,
        ),
      ),
    ],
  );
}

  //! EVENT DURATION TIME
  Widget _eventDurationTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Event Duration', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextFormField(
          controller:
              _eventDurationTimeController, // Assuming you have a controller for this field
          decoration: InputDecoration(
            hintText: "Duration in hours (e.g., 2 hours)",
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: grey.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            // Allow the field to be empty (null or empty value)
            if (value == null || value.isEmpty) {
              return null; // No validation error, it's optional
            }

            // Check if the input is a valid numeric duration (e.g., 2 hours, 90 minutes)
            if (!RegExp(r'^\d+(\s+hours|\s+minutes)?$').hasMatch(value)) {
              return 'Please enter a valid duration (e.g., 2 hours or 30 minutes)';
            }

            return null; // Valid value
          },
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }

//! TICKET PRICE
  Widget ticketPrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Price', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _ticketPriceController,
          decoration: InputDecoration(
            hintText: "Ticket Price",
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: grey.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the ticket price';
            }
            if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value)) {
              return 'Please enter a valid price (e.g., 10 or 10.50)';
            }
            if (double.tryParse(value)! <= 0) {
              return 'Price must be greater than zero';
            }
            return null;
          },
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }

//! SEAT AVAILABILITY FIELD AND AVAILABLE SEAT FOR THE EVENT
  Widget _ticketAndSeatAvailabilityFields() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Price', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _ticketPriceController,
                decoration: InputDecoration(
                  hintText: "Ticket Price",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: grey.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Ticket Price';
                  }
                  if (!RegExp(r'^\d+$').hasMatch(value)) {
                    return 'Please enter a valid Price';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16), // Space between the two fields
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Seat Availability',
                  style: TextStyle(color: Colors.white)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _seatAvailabilityCountController,
                decoration: InputDecoration(
                  hintText: "Enter seat availability",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: grey.withOpacity(0.2),
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  //! TYPE OF EVENT FIELD(SOLO/ENSEMBLE)
  Widget _buildPerformanceType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Type of Performance',
            style: TextStyle(color: Colors.white)),
        SizedBox(
          height: widget.size.height * 0.18,
          child: SelectinngEventType(
            onSelectionChanged: (index) {
              setState(() {
                _selectedEventTypeIndex = index;
              });
            },
          ),
        ),
      ],
    );
  }

//! GENRE TYPE OF EVENT

  Widget genreTypeSelecting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Choose a Music Genre',
            style: TextStyle(color: Colors.white)),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.12,
          child: GenreSelectionWidget(onGenreSelected: handleGenreSelection),
        ),
        if (selectedGenre != null && selectedGenre!.isNotEmpty)
          Text(
            "Selected Genre: $selectedGenre",
            style: const TextStyle(color: Colors.white),
          ),
      
      ],
    );
  }

  //! EMAIL FIELD FOR CONTACT SUPPORT
  Widget _emailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Email', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: "Your Email",
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: grey.withOpacity(0.2),
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
          enableInteractiveSelection: true,
          readOnly: false,
        ),
      ],
    );
  }

  //! FACEBOOK LINK FIELD
  Widget _facebookLinkField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Facebook Profile Link',
            style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _facebookLinkController,
          decoration: InputDecoration(
            hintText: "Enter Facebook profile URL",
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: grey.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return null;
            }
            // Check if the URL matches Facebook profile link pattern
            if (!RegExp(
                    r'^(https?:\/\/)?(www\.)?facebook\.com\/[a-zA-Z0-9.]+\/?$')
                .hasMatch(value)) {
              return 'Please enter a valid Facebook profile link';
            }
            return null;
          },
          keyboardType: TextInputType.url,
          style: const TextStyle(color: Colors.white),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          enableInteractiveSelection: true,
          readOnly: false,
        ),
      ],
    );
  }

//! INSTAGRAM LINK FIELD
  Widget _instagramLinkField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Instagram Profile Link',
            style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _instagramLinkController,
          decoration: InputDecoration(
            hintText: "Enter Instagram profile URL",
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: grey.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return null;
            }
            // Check if the URL matches Instagram profile link pattern
            if (!RegExp(
                    r'^(https?:\/\/)?(www\.)?instagram\.com\/[a-zA-Z0-9._]+\/?$')
                .hasMatch(value)) {
              return 'Please enter a valid Instagram profile link';
            }
            return null;
          },
          keyboardType: TextInputType.url,
          style: const TextStyle(color: Colors.white),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          enableInteractiveSelection: true,
          readOnly: false,
        ),
      ],
    );
  }

//! ADDITIONAL EVENT INSTRUCTION
  Widget _specialInstructionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Special Instructions',
            style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextFormField(
          controller:
              _specialInstructionController, // Assuming this controller is used for instructions
          maxLines: 3, // Allowing more lines for longer instructions
          decoration: InputDecoration(
            hintText: 'Enter any special instructions for the event',
            hintStyle: GoogleFonts.aBeeZee(
              color: white,
              fontWeight: FontWeight.w300,
            ),
            filled: true,
            fillColor: grey.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: grey.withOpacity(0.9)),
            ),
          ),
          style: GoogleFonts.aBeeZee(color: white, fontWeight: FontWeight.w500),
          validator: (value) {
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          enableInteractiveSelection: true,
          readOnly: false,
        ),
      ],
    );
  }

  Widget _submitButton() {
    return GlowingButton(
      text: 'Set Live',
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          try {
            OrganizerProfileAddingModal? currentUserProfile =
                await _firebaseService.getCurrentUserProfile();
            if (currentUserProfile == null || currentUserProfile.name == null) {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Unable to retrieve organizer profile')),
              );
              return;
            }
          //    if ( _locationController.text== null) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text('Please select an event location')),
          //   );
          //   return;
          // }
            // Show loading indicator
            showDialog(
              // ignore: use_build_context_synchronously
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );

            // Validate required fields
            if (_selectedEventTypeIndex == null) {
              Navigator.pop(context); // Dismiss loading
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Please select a performance type')),
              );
              return;
            }

            if (selectedGenre == null || selectedGenre!.isEmpty) {
              Navigator.pop(context); // Dismiss loading
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select a genre')),
              );
              return;
            }

            if (selectedDate == null || selectedTime == null) {
              Navigator.pop(context); // Dismiss loading
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select date and time')),
              );
              return;
            }

            // Create event modal
            final event = EventHostingModal(
              eventName: _eventNameController.text,
              organizerName: currentUserProfile.name,
             organizerId: currentUserProfile.id,
              description: _descriptionController.text,
              ticketPrice: double.tryParse(_ticketPriceController.text) ?? 0.0,
              instagramLink: _instagramLinkController.text,
              facebookLink: _facebookLinkController.text,
              email: _emailController.text,
              seatAvailabilityCount:
                  double.tryParse(_seatAvailabilityCountController.text) ?? 0.0,
              eventDurationTime:
                  double.tryParse(_eventDurationTimeController.text) ?? 0.0,
              specialInstruction: _specialInstructionController.text,
              location: _locationController.text,
              date: selectedDate,
              time: selectedTime,
              performanceType: _selectedEventTypeIndex,
              genreType: selectedGenre,
              eventRules: _eventRules,
            );

            // Convert XFile to File if image is selected
            File? imageFile;
            if (_selectedImage != null) {
              imageFile = File(_selectedImage!.path);
            }

            // Save event data and image
            await _eventService.saveEvent(event, image: imageFile);

        
           

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Event saved successfully!')),
            );
         Navigator.pushAndRemoveUntil(context, GentlePageTransition(page: EventListPage()), (route) => true);

            // Optionally navigate back or clear form
            // Navigator.pop(context); // Uncomment to go back
            _clearForm(); 
          } catch (e) {
            // Dismiss loading indicator
            Navigator.pop(context);

            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error saving event: ${e.toString()}')),
            );
          }
        }
      },
    );
  }

  void _clearForm() {
    _eventNameController.clear();
    _organizerNameController.clear();
    _descriptionController.clear();
    _ticketPriceController.clear();
    _instagramLinkController.clear();
    _facebookLinkController.clear();
    _emailController.clear();
    _seatAvailabilityCountController.clear();
    _eventDurationTimeController.clear();
    _specialInstructionController.clear();
    _locationController.clear();
    _dateController.clear();
    _timeController.clear();
    setState(() {
      selectedDate = null;
      selectedTime = null;
      selectedGenre = null;
      _selectedEventTypeIndex = null;
      _selectedImage = null;
    });
  }

  // Add these functions in your _TotalFieldsState class:
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: purple, // Your app's primary color
              onPrimary: Colors.white,
              surface: grey.withOpacity(0.2),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.grey[900],
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: purple,
              onPrimary: Colors.white,
              surface: grey.withOpacity(0.2),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.grey[900],
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }
}


